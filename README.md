# DOCKER for gstreamer + opencv + ray + yolov8  
---  
[작업 위치] Dockerfile: G:\2024\Docker-opencv-GPU  
[작업 위치] docker_run.py: G:\2023_yolov8\bentoml_test\BentoYolo  
  
[결과] Dockerfile로 mabaxterm에서 docker image 만들 경우 약 21Gb 이미지 생성 (너무 큼)  
      fizmath/gpu-opencv:latest를 이용하고 container 진입 후, ray, ultralytics설치 한 후 commit으로 이미지 생성 (약 14Gb)   
  
***** 도커 이미지 작성 절차 *****  
(1) 아래 명령을 실행하여 mobaxterm 아래서 container 안으로 진입  
  
 docker run --gpus all -it --rm -e DISPLAY=host.docker.internal:0.0 -v /g/2023_yolov8/bentoml_test/BentoYolo:/myapp -v /tmp/.X11-unix:/tmp/.X11-unix fizmath/gpu-opencv:latest  
 [배경설명] MobaXterm에서 모든 것을 실행 했음. MobaXterm은 자체로 xterminal을 가지고 있어서, docker container 내부에 생성된 display를 host에서 보여줄 수 있음.  
           이를 위해, -e DISPLAY=host.docker.internal:0.0 옵션을 사용  
           MobaXterm은 windows의 폴더 위치를 /g/2023_yolov8/bentoml_test/BentoYolo처럼 인식함 (g driver).   
   
(2) container 내에서 ray, ultralytics 설치   
 pip install ray ultralytics  
(3) ultralytics의 cv2와 gstreamer의 cv2가 충돌하므로 제거해 줌  
 pip uninstall opencv-python opencv-python-headless -y  
(4) host에서 (ray, ultralytics가 설치된) docker image 새로 생성  
 docker container ls  
 docker commit <container id> my_cctv  
(5) 테스트: mobaxterm에서 새 이미지 실행: display 성공하였음  
 docker run --gpus all -it --rm -e DISPLAY=host.docker.internal:0.0 -v /g/2023_yolov8/bentoml_test/BentoYolo:/myapp -v /tmp/.X11-unix:/tmp/.X11-unix my_cctv:latest  




# DOCKER for GStreamer + OpenCV + Ray + YOLOv8

---

## 작업 위치

- **Dockerfile**: `G:\2024\Docker-opencv-GPU`
- **docker_run.py**: `G:\2023_yolov8\bentoml_test\BentoYolo`

---

## 결과

- **Dockerfile로 MobaXterm에서 Docker 이미지 생성 시**: 약 **21GB** 이미지 생성 (너무 큼)
- **`fizmath/gpu-opencv:latest`를 이용하여 컨테이너 진입 후, `ray`, `ultralytics` 설치 후 `commit`으로 이미지 생성**: 약 **14GB**

---

## 도커 이미지 작성 절차

1. ### MobaXterm에서 컨테이너 안으로 진입

   ```bash
   docker run --gpus all -it --rm \
     -e DISPLAY=host.docker.internal:0.0 \
     -v /g/2023_yolov8/bentoml_test/BentoYolo:/myapp \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     fizmath/gpu-opencv:latest
   ```

   **배경 설명**:

   - **MobaXterm**에서 모든 작업을 실행하였습니다.
   - MobaXterm은 자체적으로 **X 터미널**을 가지고 있어, Docker 컨테이너 내부에서 생성된 디스플레이를 호스트에서 볼 수 있습니다.
   - 이를 위해 `-e DISPLAY=host.docker.internal:0.0` 옵션을 사용합니다.
   - MobaXterm은 Windows의 폴더 위치를 `/g/2023_yolov8/bentoml_test/BentoYolo`처럼 인식합니다 (`G` 드라이브).

2. ### 컨테이너 내에서 `ray`, `ultralytics` 설치

   ```bash
   pip install ray ultralytics
   ```

3. ### `ultralytics`의 `cv2`와 GStreamer의 `cv2` 충돌로 인한 제거

   ```bash
   pip uninstall opencv-python opencv-python-headless -y
   ```

4. ### 호스트에서 Docker 이미지 새로 생성 (`ray`, `ultralytics`가 설치된 상태)

   ```bash
   docker container ls
   docker commit <컨테이너_ID> my_cctv
   ```

   - `<컨테이너_ID>`를 실제 컨테이너 ID로 변경해주세요.

5. ### 테스트: MobaXterm에서 새 이미지 실행 (디스플레이 성공)

   ```bash
   docker run --gpus all -it --rm \
     -e DISPLAY=host.docker.internal:0.0 \
     -v /g/2023_yolov8/bentoml_test/BentoYolo:/myapp \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     my_cctv:latest
   ```

---

## 참고

- ### PowerShell에서 명령 실행 시 디스플레이 실패 (X-Window 미설치로 인함)

  ```bash
  docker run --gpus all -it --rm \
    -v G:\2023_yolov8\bentoml_test\BentoYolo:/myapp \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    fizmath/gpu-opencv:latest
  ```

  - **디스플레이 실패 원인**: X-Window가 없기 때문입니다.

---

**도움이 되셨길 바랍니다! 추가적인 내용이나 수정이 필요하시면 언제든지 말씀해주세요.** 
  
(c.f)  
powershell에서 명령: display 실패 (X-window가 없어서임)  
docker run --gpus all -it --rm   
-v G:\2023_yolov8\bentoml_test\BentoYolo:/myapp   
-v /tmp/.X11-unix:/tmp/.X11-unix:rw fizmath/gpu-opencv:latest  

