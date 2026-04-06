#!/usr/bin/env bats

# Basic container and deployment health checks.
# Expects a running eXist container named "exist" on port 8080.

@test "container jvm responds" {
  run docker exec exist java -version
  [ "$status" -eq 0 ]
}

@test "container reachable via http" {
  result=$(curl -Is http://127.0.0.1:8080/ | grep -o 'Jetty')
  [ "$result" == 'Jetty' ]
}

@test "container reports healthy" {
  result=$(docker ps | grep -c 'healthy')
  [ "$result" -ge 1 ]
}

@test "logs show clean start" {
  result=$(docker logs exist | grep -o 'Server has started')
  [ "$result" == 'Server has started' ]
}

@test "docs package deployed" {
  result=$(docker logs exist | grep -om 1 'http://exist-db.org/apps/docs')
  [ "$result" == 'http://exist-db.org/apps/docs' ]
}

@test "logs are error free" {
  result=$(docker logs exist | grep -ow -c 'ERROR' || true)
  [ "$result" -eq 0 ]
}

@test "no fatalities in logs" {
  result=$(docker logs exist | grep -ow -c 'FATAL' || true)
  [ "$result" -eq 0 ]
}
