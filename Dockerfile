FROM ros:noetic-ros-core

ENV SWI_HOME_DIR=/usr/lib/swi-prolog
ENV LD_LIBRARY_PATH=/usr/lib/swi-prolog/lib/x86_64-linux:$LD_LIBRARY_PATH

RUN apt update && apt install -y \
  gdb \
  g++ \
  clang \
  cmake \
  make \
  libeigen3-dev \
  libspdlog-dev \
  libraptor2-dev \
  libfmt-dev \
  software-properties-common \
  python3-catkin-tools \
  python3-catkin-pkg \
  python3-vcstool \
  python3-rosdep \
  python-is-python3 \
  ros-noetic-catkin \
  wget \
  git \
  curl \
  && rm -rf /var/lib/apt/lists/

RUN apt-add-repository ppa:swi-prolog/stable
RUN apt update
RUN apt install -y swi-prolog*

RUN curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
  sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt update && apt install -y \
  mongodb-org \
  libmongoc-dev \
  && rm -rf /var/lib/apt/lists/

RUN mkdir -p /knowrob_ws/src
WORKDIR /knowrob_ws/src
RUN ["/bin/bash", "-c", "git clone -b master https://github.com/knowrob/knowrob.git"]
RUN ["/bin/bash", "-c", "git clone https://github.com/knowrob/rosprolog.git \
  && git clone https://github.com/code-iai/iai_common_msgs.git"]

WORKDIR /knowrob_ws/
RUN ["/bin/bash", "-c", "source /opt/ros/noetic/setup.bash \
    && rosdep init \
    && apt update \
    && rosdep update \
    && rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/"]

RUN ["/bin/bash", "-c", "source /opt/ros/noetic/setup.bash && \
    catkin build"]

COPY knowrob_entrypoint.sh /knowrob_entrypoint.sh
ENTRYPOINT ["/knowrob_entrypoint.sh"]
