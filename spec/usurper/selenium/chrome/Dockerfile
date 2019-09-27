FROM selenium/standalone-chrome:3.141.59

RUN sudo apt-get update && sudo apt-get -y install python3-pip && sudo python3 -m pip install selenium

COPY --chown=seluser:seluser run_specs.sh /etc/selenium/
COPY --chown=seluser:seluser spec/* /etc/selenium/spec/

RUN chmod u+x /etc/selenium/*

ENTRYPOINT [ "/etc/selenium/run_specs.sh" ]