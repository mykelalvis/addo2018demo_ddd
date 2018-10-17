#!/bin/sh
. ~/install_config.sh

echo "Installing Maven Settings file"
mkdir ~/.m2
cat > ~/.m2/settings.xml << EOFMVEN
<?xml version="1.0" encoding="UTF-8"?>
<settings
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd"
  xmlns="http://maven.apache.org/SETTINGS/1.1.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <localRepository>\${user.home}/.m2/repository</localRepository>
  <servers>
    <server>
      <id>nexus</id>
      <username>${NEXUS_MAVEN_USER}</username>
      <password>${NEXUS_MAVEN_PASSWORD}</password>
    </server>
  </servers>
  <mirrors>
    <mirror>
<!-- You CAN Mirror everything...  <mirrorOf>*</mirrorOf> -->
      <mirrorOf>*,!snapshots</mirrorOf> <!-- We don't mirror snapshots -->
      <name>remote-repos</name>
      <url>${NEXUS}/repository/maven-public/</url>
      <id>nexus</id>
    </mirror>
  </mirrors>
  <profiles>
    <profile>
      <id>nexus-internal</id>
      <repositories>
        <repository>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
          <id>snapshots</id>
          <name>maven-snapshots</name>
          <url>${NEXUS}/repository/maven-snapshots/</url>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>snapshots</id>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
          <name>maven-snapshots</name>
          <url>${NEXUS}/repository/maven-snapshots/</url>
        </pluginRepository>
      </pluginRepositories>
      <activation>
        <activeByDefault>true</activeByDefault>
      </activation>
    </profile>
  </profiles>
</settings>
EOFMVEN

sdk install maven 

# sdk  install lazybones	# if that's your thing
