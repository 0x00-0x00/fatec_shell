#!/usr/bin/env python3.6
#coding: utf-8
import requests
import re
import hashlib
from bs4 import BeautifulSoup
from sys import stderr
import unicodedata


def remove_accents(input_str):
    nfkd_form = unicodedata.normalize('NFKD', input_str)
    return u"".join([c for c in nfkd_form if not unicodedata.combining(c)])


def gera_links(url):
    """
    Cria links para ate N paginas
    """
    n = 30
    lista = []
    for i in range(n):
        lista.append(url + "/{0}/".format(i))
    return lista


def get_page(url):
    headers = {'Accept-Encoding': 'utf-8'}
    req = requests.get(url, headers=headers)
    return remove_accents(req.text)


def format_poem(poem):
    return poem.replace("<br/>", "\n")


def get_poems(data):
    soup = BeautifulSoup(data, "lxml")
    poems = soup.find_all('p', class_='frase fr0')
    return ''.join(str(e) for e in poems)


links = gera_links("https://pensador.uol.com.br/poemas_de_fernando_pessoa")


if __name__ == "__main__":
    print('Script escrito por Andre Marques (zc00l)')
    print('github: https://github.com/0x00-0x00')
    poems = []
    hashes = []
    print('[*] Buscando poemas de Fernando Pessoa ... ')
    for url in links:
        # Get page
        content = get_page(url)

        # Filter HTML content and format string
        poems = get_poems(content)
        poems = format_poem(poems)

        # Hash the poem(s) to avoid multiplicity
        m = hashlib.md5()
        m.update(poems.encode())
        poems_hash = m.hexdigest()
        if poems_hash in hashes:
            continue
        hashes.append(poems_hash)

        # Log the data
        stderr.write("[*] Atingido: {0} | Bytes: {1}\n".format(url, len(content)))

        # Write the data to file
        with open("poemas.fernando", "a+", encoding='utf-8') as f:
            f.write(poems)




