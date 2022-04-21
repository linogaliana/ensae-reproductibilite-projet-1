FROM ubuntu:20.04

RUN apt-get -y update && \
    apt-get -y install wget

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

# Make conda command available
ENV PATH="/miniconda/bin:${PATH}"

# Copy project files on the Docker image
WORKDIR /app
COPY . /app

# Create conda env
RUN conda env create -f environment.yml

# Make container listen on port 5000
EXPOSE 5000

# Make Python interpreter from "monenv" available
ENV PATH="/miniconda/envs/monenv/bin:${PATH}"

# Install quarto
ENV QUARTO_VERSION="0.9.287"
RUN wget "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb"
RUN apt install "./quarto-${QUARTO_VERSION}-linux-amd64.deb"

# Launch Python script at container startup
CMD ["python", "main.py"]
