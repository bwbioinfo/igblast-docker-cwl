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
    libuv1-dev \
    ncbi-blast+

# Download and install igblast
RUN wget ftp://ftp.ncbi.nih.gov/blast/executables/igblast/release/1.22.0/ncbi-igblast-1.22.0-x64-linux.tar.gz && \
    tar -xzf ncbi-igblast-1.22.0-x64-linux.tar.gz && \
    rm ncbi-igblast-1.22.0-x64-linux.tar.gz && \
    mv ncbi-igblast-1.22.0 /opt/igblast

# Set environment variables
ENV PATH="/opt/igblast/bin:${PATH}"

# Set the working directory
WORKDIR /opt

# Create the data directory
RUN mkdir data

WORKDIR /opt/data

# Download Immunoglobulin and T Cell Receptor sequences from IMGT
RUN for chain in IGHV IGHD IGHJ IGKV IGKJ IGLV IGLJ; do wget "https://www.imgt.org/download/V-QUEST/IMGT_V-QUEST_reference_directory/Homo_sapiens/IG/${chain}.fasta"; done
# Download Immunoglobulin and T Cell Receptor sequences from IMGT
RUN for chain in TRAV TRAJ TRBV TRBD TRBJ TRDV TRDD TRDJ TRGV TRGJ ; do wget "https://www.imgt.org/download/V-QUEST/IMGT_V-QUEST_reference_directory/Homo_sapiens/TR/${chain}.fasta"; done

RUN edit_imgt_file.pl TR*D.fasta > imgt.Homo_sapiens.tcrD.f.orf && \
edit_imgt_file.pl TR*V.fasta > imgt.Homo_sapiens.tcrV.f.orf && \
edit_imgt_file.pl TR*J.fasta > imgt.Homo_sapiens.tcrJ.f.orf && \
edit_imgt_file.pl IG*D.fasta > imgt.Homo_sapiens.igD.f.orf && \
edit_imgt_file.pl TR*V.fasta > imgt.Homo_sapiens.igV.f.orf && \
edit_imgt_file.pl TR*J.fasta > imgt.Homo_sapiens.igJ.f.orf

RUN mkdir /opt/igblast/database

RUN makeblastdb -in imgt.Homo_sapiens.tcrD.f.orf -dbtype nucl -parse_seqids -out /opt/igblast/database/Homo_sapiens_tcrD_db && \
    makeblastdb -in imgt.Homo_sapiens.tcrV.f.orf -dbtype nucl -parse_seqids -out /opt/igblast/database/Homo_sapiens_tcrV_db && \
    makeblastdb -in imgt.Homo_sapiens.tcrJ.f.orf -dbtype nucl -parse_seqids -out /opt/igblast/database/Homo_sapiens_tcrJ_db && \
    makeblastdb -in imgt.Homo_sapiens.igD.f.orf -dbtype nucl -parse_seqids -out /opt/igblast/database/Homo_sapiens_igD_db && \
    makeblastdb -in imgt.Homo_sapiens.igV.f.orf -dbtype nucl -parse_seqids -out /opt/igblast/database/Homo_sapiens_igV_db && \
    makeblastdb -in imgt.Homo_sapiens.igJ.f.orf -dbtype nucl -parse_seqids -out /opt/igblast/database/Homo_sapiens_igJ_db

WORKDIR /opt/igblast

# Test igblast
RUN igblastn -h

COPY ./test_data/ /data/

RUN igblastn \
    -query /data/test_data.fasta \
    -germline_db_V database/Homo_sapiens_igV_db \
    -germline_db_J database/Homo_sapiens_igJ_db \
    -germline_db_D database/Homo_sapiens_igD_db \
    -organism human \
    -show_translation

# Set the run command for igblast
CMD ["igblastn"]