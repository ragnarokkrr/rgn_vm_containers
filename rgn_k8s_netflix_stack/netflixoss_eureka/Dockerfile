#https://hub.docker.com/r/netflixoss/eureka/
#https://github.com/Netflix-Skunkworks/zerotodocker/blob/master/eureka/1.3.1/Dockerfile

FROM netflixoss/tomcat:7.0.64
MAINTAINER Netflix Open Source Development <talent@netflix.com>


RUN cd /tomcat/webapps &&\
  mkdir eureka &&\
  cd eureka &&\
  wget -q http://repo1.maven.org/maven2/com/netflix/eureka/eureka-server/1.8.6/eureka-server-1.8.6.war &&\
  jar xf eureka-server-1.8.6.war &&\
  rm eureka-server-1.8.6.war

ADD config.properties /tomcat/webapps/eureka/WEB-INF/classes/config.properties
ADD eureka-client-test.properties /tomcat/webapps/eureka/WEB-INF/classes/eureka-client-test.properties
ADD eureka-server-test.properties /tomcat/webapps/eureka/WEB-INF/classes/eureka-server-test.properties

EXPOSE 8080

ENTRYPOINT ["/tomcat/bin/catalina.sh"]

CMD ["run"]