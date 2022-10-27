FROM node:16.18.0-alpine3.15 as node

FROM httpd:2.4.54-bullseye as apache

FROM php:8.0.24-apache-bullseye as php

FROM mariadb:10.7.6-focal as mariadb

FROM python:3.9.15-slim-bullseye as python

FROM openjdk:11.0.14.1-jre-slim-bullseye as openjdk
