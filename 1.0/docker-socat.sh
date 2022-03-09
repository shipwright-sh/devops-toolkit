#!/bin/sh

if [ "${DOCKER_SOCAT_DEBUG:-false}" != "false" ] ; then
  set -x
  env
fi

WHOAMI="${SUDO_USER:-$(whoami)}"
DOCKER_GROUP="docker-host"
HOST_SOCKET="/var/run/docker-host.sock"
DOCKER_SOCKET="/var/run/docker.sock"

sudoIf() {
  if [ "$(id -u)" -ne 0 ] ; then
    sudo "${@}"
  else
    "${@}"
  fi
}

socatIf() {
  if [ -S "${HOST_SOCKET}" ] ; then
    SOCKET_GID="$(stat -c '%g' "${HOST_SOCKET}")"
    if [ "${SOCKET_GID}" != "0" ] ; then
      if [ "$(grep ":${SOCKET_GID}:" /etc/group)" = "" ] ; then
        sudoIf addgroup -g "${SOCKET_GID}" "${DOCKER_GROUP}"
      else
        DOCKER_GROUP="$(awk \
          -F: "(\$3 == ${SOCKET_GID}) { print \$1 }" /etc/group)"
      fi
      GROUPSEARCH="${SOCKET_GID}(${DOCKER_GROUP})"
      if [ "$(id "${WHOAMI}" | grep "${GROUPSEARCH}")" = "" ] ; then
        sudoIf addgroup "${WHOAMI}" "${DOCKER_GROUP}"
        sudo -u "${WHOAMI}" newgrp "${DOCKER_GROUP}"
      fi
    else
      if [ -S "${DOCKER_SOCKET}" ] ; then
        sudoIf rm "${DOCKER_SOCKET}"
      fi
      sudoIf socat \
        "UNIX-LISTEN:${DOCKER_SOCKET},fork,mode=660,user=${WHOAMI}" \
        "UNIX-CONNECT:${HOST_SOCKET}" >> /tmp/docker-socket.log 2>&1 &
    fi
  fi
}

socatIf