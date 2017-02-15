#!/bin/bash
# Shell script escrito por Lucas Santos
echo "Digite o nome do arquivo que deseja buscar: "
read nome
ls | grep $nome
