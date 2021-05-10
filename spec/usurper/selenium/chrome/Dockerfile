FROM selenium/standalone-chrome:3.141.59

USER root

RUN apt-get update && \
        apt-get -y --no-install-recommends install python3-pip && \
        python3 -m pip install selenium && \
        rm -rf /var/lib/apt/lists/*

COPY --chown=seluser:seluser run_specs.sh /etc/selenium/
COPY --chown=seluser:seluser spec/* /etc/selenium/spec/

RUN chmod u+x /etc/selenium/*

USER seluser

ENTRYPOINT [ "/etc/selenium/run_specs.sh" ]