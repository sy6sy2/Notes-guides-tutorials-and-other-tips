#!/usr/bin/python
# -*- coding: utf-8 -*-

from wakeonlan import wol

wol.send_magic_packet('**:**:**:**:**:**' ,ip_address='xxxxxxxxxxx', port=9)
