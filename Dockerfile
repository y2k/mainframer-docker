FROM runmymind/docker-android-sdk:latest

RUN apt-get update && apt-get install -y openssh-server rsync
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
# CMD chmod 700 ~/.ssh
# CMD chmod 600 ~/.ssh/authorized_keys

RUN rm -r /opt/android-sdk-linux/ndk-bundle/

RUN echo "\nexport ANDROID_SDK_ROOT=/opt/android-sdk-linux\nexport ANDROID_HOME=/opt/android-sdk-linux\n" >> /root/.bashrc
RUN echo "cp /root/.ssh/_authorized_keys /root/.ssh/authorized_keys && /usr/sbin/sshd -D" > /root/run.sh
RUN chmod +x /root/run.sh

CMD /root/run.sh

# CMD ["cp /root/.ssh/_authorized_keys /root/.ssh/authorized_keys", "&&", "/usr/sbin/sshd", "-D"]

