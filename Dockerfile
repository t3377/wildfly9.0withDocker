FROM jboss/wildfly

ENV  ALPN_VERSION 8.1.3.v20150130
ENV  ALPN_LIB_DIR /opt/jboss/wildfly/standalone/configuration/lib
ENV  HTTP2_ENABLE_CLI offlinecli-http2.cli

# Add x509 certificates
ADD keystore.jks   /opt/jboss/wildfly/standalone/configuration/keystore.jks
ADD truststore.jks /opt/jboss/wildfly/standalone/configuration/truststore.jks

# APLN driver
RUN mkdir -p $ALPN_LIB_DIR
RUN curl http://central.maven.org/maven2/org/mortbay/jetty/alpn/alpn-boot/$ALPN_VERSION/alpn-boot-$ALPN_VERSION.jar > $ALPN_LIB_DIR/alpn-boot-$ALPN_VERSION.jar
ENV JAVA_OPTS "$JAVA_OPTS -Xbootclasspath/p:$ALPN_LIB_DIR/alpn-boot-$ALPN_VERSION.jar"

# Copy cli script
ADD $HTTP2_ENABLE_CLI /tmp/

#Offline batch execution
RUN  /opt/jboss/wildfly/bin/jboss-cli.sh --file=/tmp/$HTTP2_ENABLE_CLI
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]
