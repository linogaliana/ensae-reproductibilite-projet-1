FROM ubuntu:20.04

RUN apt-get -y update && \
    apt-get -y install wget

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /miniconda && \
    rm -f Miniconda3-latest-Linux-x86_64.sh

# Make conda command available
ENV PATH="/miniconda/bin:${PATH}"

# Create conda env
COPY environment.yml .
RUN conda env create -f environment.yml

# Copy project files on the Docker image
WORKDIR /app
COPY . /app

ENV QUARTO_VERSION="0.9.243"
RUN wget "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb"
RUN sudo apt install ./quarto-0.9.243-linux-amd64.deb

# Make Python interpreter from "monenv" available
ENV PATH="/miniconda/envs/monenv/bin:${PATH}"

# Make container listen on port 5000
EXPOSE 5000



# Launch Python script at container startup
CMD ["python", "main.py"]