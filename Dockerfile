FROM debian

# 更新软件包列表
RUN apt update

# 安装必要的软件包
RUN DEBIAN_FRONTEND=noninteractive apt install qemu-kvm *zenhei* xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor  git xfce4 xfce4-terminal tightvncserver wget -y

# 下载noVNC和Proot
RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz
RUN curl -LO https://proot.gitlab.io/proot/bin/proot
RUN chmod 755 proot
RUN mv proot /bin

# 解压noVNC
RUN tar -xvf v1.2.0.tar.gz

# 创建VNC密码文件
RUN mkdir $HOME/.vnc
RUN echo 'luo' | vncpasswd -f > $HOME/.vnc/passwd
RUN chmod 600 $HOME/.vnc/passwd

# 创建启动脚本luo.sh
RUN echo 'whoami' >> /luo.sh
RUN echo 'cd' >> /luo.sh
RUN echo "su -l -c 'vncserver :2000 -geometry 1280x800'" >> /luo.sh
RUN echo 'cd /noVNC-1.2.0' >> /luo.sh
RUN echo './utils/launch.sh --vnc localhost:7900 --listen 8900' >> /luo.sh
RUN chmod 755 /luo.sh

# 安装Nginx
RUN apt install nginx -y

# 复制网站代码到容器中
COPY your_website_directory /usr/share/nginx/html

# 声明容器将监听端口8900
EXPOSE 8900

# 启动VNC和noVNC Web客户端
CMD /luo.sh