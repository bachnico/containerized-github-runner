FROM ghcr.io/actions/actions-runner:latest

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN sudo chmod +x start.sh

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
