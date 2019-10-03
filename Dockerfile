FROM java:openjdk-8
MAINTAINER liming

COPY target/onlineshopping-1.0-SNAPSHOT.jar /onlineshopping.jar

ENTRYPOINT ["java","-jar","/onlineshopping.jar"]