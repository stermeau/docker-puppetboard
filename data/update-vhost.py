#!/usr/bin/env python

import jinja2
import os

puppetboard_apache_conf = '/etc/apache2/sites-available/puppetboard'
vhost_tpl               = '/srv/puppetboard/template/puppetboard.jinja'

webdoc_dir         = os.getenv('WEBDOC_DIR', '/srv/puppetboard/http')
puppetboard_py_dir = os.getenv('PUPPETBOARD_PY_DIR', '/usr/local/lib/python2.7/dist-packages/puppetboard')

ldap_enable        = os.getenv('LDAP_ENABLE', False)
ldap_host          = os.getenv('LDAP_HOST', None)
ldap_base          = os.getenv('LDAP_BASE', None)
ldap_auth_user     = os.getenv('LDAP_USER', None)
ldap_auth_pass     = os.getenv('LDAP_PASS', None)

ldap_user_enable   = os.getenv('LDAP_USER_ENABLE', False)
ldap_user          = os.getenv('LDAP_USER', None)

ldap_group_enable  = os.getenv('LDAP_GROUP_ENABLE', True)
ldap_group         = os.getenv('LDAP_GROUP', None)

inventory_dir      = os.getenv('INVENTORY_DIR', None)


templateLoader = jinja2.FileSystemLoader(searchpath='/')
templateEnv    = jinja2.Environment(loader=templateLoader)

template = templateEnv.get_template(vhost_tpl)

if type(ldap_enable) is str:
    ldap_enable = ldap_enable.strip('\"\'')

if type(ldap_host) is str:
    ldap_host = ldap_host.strip('\"\'')

if type(ldap_base) is str:
    ldap_base = ldap_base.strip('\"\'')

if type(ldap_auth_user) is str:
    ldap_auth_user = ldap_auth_user.strip('\"\'')

if type(ldap_auth_pass) is str:
    ldap_auth_pass = ldap_auth_pass.strip('\"\'')

if type(ldap_user_enable) is str:
    ldap_user_enable = ldap_user_enable.strip('\"\'')

if type(ldap_user) is str:
    ldap_user = ldap_user.strip('\"\'')

if type(ldap_group_enable) is str:
    ldap_group_enable = ldap_group_enable.strip('\"\'')

if type(ldap_group) is str:
    ldap_group = ldap_group.strip('\"\'')

if type(inventory_dir) is str:
    inventory_dir = inventory_dir.strip('\"\'')

# Format to the right syntax
ldap_host  = ldap_host.replace(';', ' ')
ldap_user  = ldap_user.replace(';', ' ')
ldap_group = ldap_group.replace(';', ' ')

templateVars = {}

templateVars.update({ 'webdoc_dir': webdoc_dir })
templateVars.update({ 'puppetboard_py_dir': puppetboard_py_dir })
templateVars.update({ 'ldap_enable': ldap_enable })
templateVars.update({ 'ldap_host': ldap_host })
templateVars.update({ 'ldap_base': ldap_base })
templateVars.update({ 'ldap_auth_user': ldap_auth_user })
templateVars.update({ 'ldap_auth_pass': ldap_auth_pass })
templateVars.update({ 'ldap_user_enable': ldap_user_enable })
templateVars.update({ 'ldap_user': ldap_user })
templateVars.update({ 'ldap_group_enable': ldap_group_enable })
templateVars.update({ 'ldap_group': ldap_group })
templateVars.update({ 'inventory_dir': inventory_dir })

outputText = template.render(templateVars)

f = open(puppetboard_apache_conf, 'w')
f.write(outputText)
f.close()
