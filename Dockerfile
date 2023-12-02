#cd docker && docker build -t itmt -f Dockerfile . 
#docker run --gpus all -it itmt
FROM nvidia/cuda:11.7.1-cudnn8-runtime-ubuntu20.04

WORKDIR /Scripts/BASHSCRIPT
##/DualNetENE
#ADD . /DualNetENE

# Since wget is missing
RUN apt-get update && apt-get install -y wget

#Install MINICONDA
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O Miniconda.sh && \
  /bin/bash Miniconda.sh -b -p /opt/conda && \
  rm Miniconda.sh

ENV PATH /opt/conda/bin:$PATH

# Install gcc as it is missing in our base layer
RUN apt-get update && apt-get -y install gcc && apt install -y libgl1

#ENV OPENCV_VER 3.3.0
#ENV OPENCV https://github.com/opencv/opencv/archive/${OPENCV_VER}.tar.gz

##RUN pip install --no-cache-dir opencv-python


COPY DualNetENE.yml .
RUN conda env create -f DualNetENE.yml

# Make RUN commands use the new environment:
##CMD ["conda", "run", "-n", "DualNetENE", "/bin/bash", "-c"]

##CMD [ "/bin/conda", "run", "-n", "DualNetENE", "/bin/bash" ]

##RUN conda activate DualNetENE

#COPY Model ./Model
#COPY /Input /Input
#COPY /Output /Output

COPY /Scripts/src/ /Scripts/src/
COPY /Scripts/src/calibration.py /Scripts/src/calibration.py
COPY /Scripts/src/contour_variance.py /Scripts/src/contour_variance.py 
COPY /Scripts/src/data_ene_test.py /Scripts/src/data_ene_test.py 
COPY /Scripts/src/model_callbacks.py /Scripts/src/model_callbacks.py
COPY /Scripts/src/model_multi_dual.py /Scripts/src/model_multi_dual.py
COPY /Scripts/src/preprocessingroi_nrrd.py /src/preprocessingroi_nrrd.py
COPY /Scripts/src/rescale.py /Scripts/src/rescale.py
COPY /Scripts/src/test_ene.py /Scripts/src/test_ene.py
COPY /Scripts/src/util.py /Scripts/src/util.py

COPY /Scripts/utils/ /Scripts/utils/
COPY /Scripts/utils/crop_roi.py /Scripts/utils/crop_roi.py
COPY /Scripts/utils/dcm_to_nrrd.py /Scripts/utils/dcm_to_nrrd.py
COPY /Scripts/utils/interpolate.py /Scripts/utils/interpolate.py
COPY /Scripts/utils/util.py /Scripts/utils/util.py

COPY /Scripts/BASHSCRIPT/ /Scripts/BASHSCRIPT/
#COPY ./Scripts/BASHSCRIPT/BioImClass_preprocessing.sh /
#COPY ./Scripts/BASHSCRIPT/BioImClass_test.sh / 

EXPOSE 5000

CMD ["conda", "run", "-n", "DualNetENE", "/bin/bash", "/Scripts/BASHSCRIPT/BioImClass_preprocessing.sh", "-i", "/Input", "-o", "/Output"]
#CMD ["conda", "run", "-n", "DualNetENE", "/bin/bash", "/Scripts/BASHSCRIPT/BioImClass_test.sh", "-i", "/InputIM", "-j", "/InputLA", "-o", "/Output", "-m", "/DualNetENE-20220208-1531.h5"]
