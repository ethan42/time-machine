## Basic time-machine Dockerfile template to provision Debian
## with packages from a specific date in time. Useful for
## reproducibility, testing, and debugging.

# Build arguments populated to build a stretch image from Nov 2017 for exim4.

# Build the image with:
# docker build -t ethan42/exim4:stretch-20171101 \
#   --build-arg RELEASE=stretch \
#   --build-arg SNAPSHOT=20171101T034619Z \
#   --build-arg PACKAGE=exim4 .

# Make the release a build arg with a stretch default
ARG RELEASE=stretch

# Use the base image as the first stage
FROM debian:${RELEASE} AS base

# Set the release as an environment variable
ARG RELEASE

# Snapshot date we would like to get tested
ARG SNAPSHOT=20171101T034619Z

# Name of package we would like to get installed from that date
ARG PACKAGE=exim4

# Set the deb source to the snapshot date
RUN echo deb http://snapshot.debian.org/archive/debian/${SNAPSHOT} ${RELEASE} main > /etc/apt/sources.list

# Update the package list and install aptitude
RUN apt update && apt install -fy aptitude --force-yes

# Force install a package and use aptitude to handle problematic dep issues
RUN aptitude -fy -q install ${PACKAGE} -o Aptitude::ProblemResolver::SolutionCost='new'
