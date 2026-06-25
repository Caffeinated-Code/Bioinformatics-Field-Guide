FROM condaforge/miniforge3:latest

LABEL org.opencontainers.image.title="Bioinformatics Starter"
LABEL org.opencontainers.image.description="Beginner-friendly bioinformatics environment for tutorials, notebooks, and reproducible setup checks."

WORKDIR /workspace

COPY environment.yml /tmp/environment.yml

RUN mamba env create -f /tmp/environment.yml && \
    mamba clean --all --yes

SHELL ["conda", "run", "-n", "bioinfo-starter", "/bin/bash", "-c"]

RUN python -m ipykernel install \
    --name bioinfo-starter \
    --display-name "Python (bioinfo-starter)" \
    --sys-prefix

EXPOSE 8888

CMD ["conda", "run", "--no-capture-output", "-n", "bioinfo-starter", "jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--ServerApp.token=bioinfo"]
