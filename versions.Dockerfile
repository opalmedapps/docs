FROM node:16.19.0-alpine3.16 as node

FROM httpd:2.4.55-bullseye as apache

FROM php:8.0.27-apache-bullseye as php

FROM mariadb:10.7.7-focal as mariadb

FROM python:3.9.16-slim-bullseye as python

FROM openjdk:11.0.16-jre-slim-bullseye as openjdk
