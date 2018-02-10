# VirtualEnv
#
# REPOSITORY localrepo/virtualenv
# VERSION 1.0.0

FROM centos:6.6

# Add EPEL Repository
RUN rpm --quiet -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# Add RPMforge for CentOS 6
#RUN rpm --quiet -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
#RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt

# Download and install all updates
RUN yum -q -y update

# Install base packages
RUN yum -q -y install yum-plugin-priorities python-setuptools wget git subversion tar bzip2 unzip glibc-common

# Clean up yum caches
RUN yum -q clean all

# Install and configure supervisor
RUN easy_install -q supervisor && mkdir -p /var/log/supervisor && chown -R root:root /var/log/supervisor && chmod 700 /var/log/supervisor
ADD etc/supervisord.conf /etc/supervisor/supervisord.conf
ADD etc/sshd.conf /etc/supervisor/conf.d/sshd.conf

# reinstall glibc-common to make all locales available
RUN yum reinstall -y glibc-common
RUN echo -e "LC_ALL=en_US.UTF-8\nLANG=en_US.UTF-8" > /etc/sysconfig/i18n

# change locale to Europe/Stockholm
RUN ln -fs /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# Add startup script
ADD start /start
RUN chown -R root:root /start && chmod -R 755 /start

# Change root password
RUN echo "root:mobydick" | chpasswd

ADD etc/90-nproc.conf /etc/security/limits.d/90-nproc.conf

# Expose supervisord ports
EXPOSE 22 59001

# Run supervisord
CMD ["/start/supervisord"]
