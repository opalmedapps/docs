FROM node:16.15.0-alpine3.15 as node

FROM httpd:2.4.53-bullseye as apache

FROM php:8.0.19-apache-bullseye as php

FROM mariadb:10.7.3-focal as mariadb

FROM python:3.9.10-slim-bullseye as python

FROM openjdk:11.0.14.1-jre-slim-bullseye as openjdk
