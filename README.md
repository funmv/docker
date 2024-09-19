DOCKER for gstreamer + opencv + ray + yolov8  
  
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
  
(c.f)  
powershell에서 명령: display 실패 (X-window가 없어서임)  
docker run --gpus all -it --rm   
-v G:\2023_yolov8\bentoml_test\BentoYolo:/myapp   
-v /tmp/.X11-unix:/tmp/.X11-unix:rw fizmath/gpu-opencv:latest  

