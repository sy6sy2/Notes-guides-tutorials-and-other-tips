#!/usr/bin/python
# -*- coding: utf-8 -*-
import requests
import os.path
from bs4 import BeautifulSoup
import re
import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText
from email.MIMEBase import MIMEBase
import email.Encoders as encoders
import ntpath


# Variables globales ####################################################



fromaddr = 'c*****.s********@***.***'
bccaddr = ['********.*****@***.***', '*******.*****@***.***']

# URL des différentes pages
url_root = 'http://www.fmv.ulg.ac.be/'
url_horaire = 'http://www.fmv.ulg.ac.be/cms/c_252999/horaires-des-cours/'
url_gmv1 = 'http://www.fmv.ulg.ac.be/cms/c_268056/gmv-1/'
login_url = 'https://www.intranet.ulg.ac.be/login'

# patload pour la connexion
payload = {
    "id": "******",
    "password": "******",
    "request_uri2": "http://www.fmv.ulg.ac.be/front/login.jsp?redirect=\
    http://www.fmv.ulg.ac.be/&portal=c_9813",
    "zone": "ulg",
    "login": "Dummy"
}


# Fichiers de sauvegarde des dates antérieurs
# last_horaire_file_path = '/home/user/last_horaire'
# last_gmv1_file_path = '/home/user/last_gmv1'
last_horaire_file_path = './last_horaire'
last_gmv1_file_path = './last_gmv1'

object_mail_horaire = 'CHANGEMENT EDT : Mise à jour de la page \"Horaires des cours\"'
object_mail_gmv1 = 'CHANGEMENT EDT : Mise à jour de la page \"GMV 1\"'

common_text_mail = "Une mise à jour de l'emploi du temps a eu lieu ! \n\n"

text_mail_horaire = "La page \"Horaires des cours\" a\
                    été mise à jour : "  # Indiquer ici la dernière date
text_mail_horaire_2 = "Attention ; il est possible que la mise à jour concerne les bacheliers,\
                       se référer à l'extrait de la page web ci-dessous\
                       ainsi qu'au(x) pièce(s) jointe(s)."

text_mail_gmv1 = "La page \"GMV 1\" a été mise à\
                  jour : "  # Indiquer ici la dernière date
text_mail_gmv1_2 = "Se référer à l'extrait de la page web ci-dessous ainsi \
                    qu'au(x) pièce(s) jointe(s)."

gmail_password = "*************"
gmail_smtp = "smtp.gmail.com"
gmail_port = 587


##########################################################################

# Chargement des pages et parsage ##########################################


# Authentification
session_requests = requests.session()
result = session_requests.post(
    login_url,
    data=payload,
    headers=dict(referer=login_url)
)

# Chargement des pages et parsage
page_horaire = session_requests.get(
    url_horaire,
    headers=dict(referer=url_horaire)
)
soup_horaire = BeautifulSoup(page_horaire.text, "html.parser")

page_gmv1 = session_requests.get(
    url_gmv1,
    headers=dict(referer=url_gmv1)
)
soup_gmv1 = BeautifulSoup(page_gmv1.text, "html.parser")

# Recherche des dates de mise à jour des pages
datemaj_horaire = soup_horaire.find('div', attrs={'id': 'datemaj'})
datemaj_horaire = datemaj_horaire.text.encode('utf-8')
datemaj_horaire = datemaj_horaire.replace("Version imprimable", '')
datemaj_horaire = ' '.join(datemaj_horaire.split())

datemaj_gmv1 = soup_gmv1.find("div", attrs={'id': "datemaj"})
datemaj_gmv1 = datemaj_gmv1.text.encode('utf-8')
datemaj_gmv1 = datemaj_gmv1.replace("Version imprimable", '')
datemaj_gmv1 = ' '.join(datemaj_gmv1.split())


# print 'datemaj_horaire : '+datemaj_horaire
# print 'datemaj_gmv1 : '+datemaj_gmv1
# print ''

# Regardons s'il y a eu des modifs de puis la denrière fois
new_modif_horaire = True
new_modif_gmv1 = True

last_horaire = ""
if os.path.exists(last_horaire_file_path):      # Si le fichier existe déjà
    last_horaire_file = open(last_horaire_file_path, 'r')  # On l'ouvre
    last_horaire = last_horaire_file.read()
    last_horaire_file.close()
    if last_horaire == datemaj_horaire:  # On compare avec la valeur actuelle
        new_modif_horaire = False
    else:
        last_horaire_file = open(last_horaire_file_path, "w")
        last_horaire_file.write(datemaj_horaire)
        last_horaire_file.close()
else:
    new_modif_horaire = False
    last_horaire_file = open(last_horaire_file_path, "w")
    last_horaire_file.write(datemaj_horaire)
    last_horaire_file.close()


last_gmv1 = ""
if os.path.exists(last_gmv1_file_path):     # Si le fichier existe déjà
    last_gmv1_file = open(last_gmv1_file_path, 'r')  # On l'ouvre
    last_gmv1 = last_gmv1_file.read()
    last_gmv1_file.close()
    if last_gmv1 == datemaj_gmv1:   # On compare avec la valeur actuelle
        new_modif_gmv1 = False
    else:
        last_gmv1_file = open(last_gmv1_file_path, "w")
        last_gmv1_file.write(datemaj_gmv1)
        last_gmv1_file.close()
else:
    new_modif_gmv1 = False
    last_gmv1_file = open(last_gmv1_file_path, "w")
    last_gmv1_file.write(datemaj_gmv1)
    last_gmv1_file.close()


##########################################################################


# Envoi des mails si besoin ##########################################

if new_modif_horaire is True:
    # print 'Il y a eu une modification sur la page Horaire'
    # print 'La mise à jour précédente remontait à : '+last_horaire
    # print 'La nouvelle mise à jour remonte à : '+datemaj_horaire
    # print ''

    content = re.compile(r'<h2>Masters</h2>(.*?)<h2>Masters de sp', re.DOTALL).findall(page_horaire.text)[0].encode('utf-8') # String
    soup = BeautifulSoup(content, 'html.parser')  # Soup object
    soup_text = soup.text.encode('utf-8')

    liens = ""
    url = []
    filename_url = []
    extension_url = []
    for a in soup.findAll('a'):
        liens = liens + a.text.encode('utf-8') + '\t-->\t' + url_root + a['href'].encode('utf-8') + '\n'
        current_url = requests.head(url_root + a['href'], allow_redirects=True).url
        url.append(current_url)
        current_filename, current_ext = os.path.splitext(ntpath.basename(current_url))
        filename_url.append(current_filename)
        extension_url.append(current_ext)

    msg = MIMEMultipart()
    msg['From'] = 'Changement EDT ULg'
    msg['Subject'] = object_mail_horaire

    message = """\
    <html>
      <head>%s <b>%s</b></head>
      <body>
        <p>
            %s
        </p>
        <p><i>
            %s
        </i></p>
        <p><b>
            Liens utiles de la page web :
        </b></p>
        <p>
            %s
        </p>
      </body>
    </html>
    """ % (text_mail_horaire, datemaj_horaire, text_mail_horaire_2, "<br />".join(soup_text.split("\n")), "<br />".join(liens.split("\n")))

    msg.attach(MIMEText(message, 'html'))

    for url, name, ext in zip(url, filename_url, extension_url):
        print url + '\n' + name + '\n' + ext + '\n'
        if ext is not '' and len(ext) < 6:
            # print 'C est un fichier'
            r = session_requests.get(url)
            with open("/tmp/" + name + ext, 'wb') as f:
                for chunk in r.iter_content(chunk_size=1024):
                    if chunk:  # filter out keep-alive new chunks
                        f.write(chunk)
            attachment = open("/tmp/" + name + ext, "rb")
            part = MIMEBase('application', 'octet-stream')
            part.set_payload((attachment).read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', "attachment; filename= %s" % name + ext)
            msg.attach(part)

    server = smtplib.SMTP(gmail_smtp, gmail_port)
    server.starttls()
    server.login(fromaddr, gmail_password)
    text = msg.as_string()
    server.sendmail(fromaddr, bccaddr, text)
    server.quit()


if new_modif_gmv1 is True:

    # print 'Il y a eu une modification sur la page GMV 1'
    # print 'La mise à jour précédente remontait à : '+last_gmv1
    # print 'La nouvelle mise à jour remonte à : '+datemaj_gmv1
    # print ''

    content_soup = soup_gmv1.find('div', attrs={'class': 'wysiwyg classic'})
    content_text = content_soup.text.encode('utf-8')

    liens = ""
    url = []
    filename_url = []
    extension_url = []
    for a in content_soup.findAll('a'):
        liens = liens+a.text.encode('utf-8') +' \t-->\t' + url_root + a['href'].encode('utf-8') + '\n'
        current_url = session_requests.head(url_root + a['href'], allow_redirects=True).url
        url.append(current_url)
        current_filename, current_ext = os.path.splitext(ntpath.basename(current_url))
        filename_url.append(current_filename)
        extension_url.append(current_ext)

    msg = MIMEMultipart()
    msg['From'] = 'Changement EDT ULg'
    msg['Subject'] = object_mail_gmv1

    message = """\
    <html>
      <head>%s <b>%s</b></head>
      <body>
        <p>
            %s
        </p>
        <p><i>
            %s
        </i></p>
        <p><b>
            Liens utiles de la page web :
        </b></p>
        <p>
            %s
        </p>
      </body>
    </html>
    """ % (text_mail_gmv1, datemaj_gmv1, text_mail_gmv1_2, "<br />".join(content_text.split("\n")), "<br />".join(liens.split("\n")) )

    msg.attach(MIMEText(message, 'html'))

    for url, name, ext in zip(url, filename_url, extension_url):
        print url + '\n' + name + '\n' + ext + '\n'
        if ext is not '' and len(ext) < 6:
            # print 'C est un fichier'

            r = session_requests.get(url)
            with open("/tmp/" + name + ext, 'wb') as f:
                for chunk in r.iter_content(chunk_size=1024):
                    if chunk:  # filter out keep-alive new chunks
                        f.write(chunk)

            attachment = open("/tmp/" + name + ext, "rb")
            part = MIMEBase('application', 'octet-stream')
            part.set_payload((attachment).read())
            encoders.encode_base64(part)
            part.add_header('Content-Disposition', "attachment; filename= %s" % name + ext)

            msg.attach(part)

    server = smtplib.SMTP(gmail_smtp, gmail_port)
    server.starttls()
    server.login(fromaddr, gmail_password)
    text = msg.as_string()
    server.sendmail(fromaddr, bccaddr, text)
    server.quit()
