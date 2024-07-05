FROM ubuntu:latest

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    wget \
    zlib1g-dev \
    libncurses5-dev \
    libboost-all-dev \
    libssl-dev \
    libmysqlclient-dev \
    libsqlite3-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libuv1-dev

# Download and install igblast
RUN wget ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/1.17.0/ncbi-igblast-1.17.0-x64-linux.tar.gz && \
    tar -xzf ncbi-igblast-1.17.0-x64-linux.tar.gz && \
    rm ncbi-igblast-1.17.0-x64-linux.tar.gz && \
    mv ncbi-igblast-1.17.0 /opt/igblast

# Set environment variables
ENV PATH="/opt/igblast/bin:${PATH}"

# Set the working directory
WORKDIR /opt

# Test igblast
RUN igblastn -h

# Set the run command for igblast
CMD ["igblastn"]