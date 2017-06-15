## Grafana on Cloud Foundry


### How to deploy to Pivotal Web Services


```
git clone https://github.com/making/cf-grafana.git
cd cf-grafana
wget https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.3.2.linux-x64.tar.gz 
tar -zxvf grafana-4.3.2.linux-x64.tar.gz 
mv grafana-4.3.2 grafana
# In case of Pivotal Web Services
cf create-service cleardb spark grafana-db
# In case of Pivotal Cloud Foundry
cf create-service p-mysql 100mb-dev grafana-db
cf push my-grafana
```

Go to https://my-grafana.cfapps.io

> If you use free `spark` plan of `cleardb` service, you'll have pretty bad experiences because the number of connections allowed by ClearDb is only `4`.
>
> If you don't need to persist dashboards and users, you can use default sqlite3 as follows:
>
> ```
> sed -i -e 's|^http_port = 3000$|http_port = 8080|' ./conf/defaults.ini
> cf push my-grafana -b binary_buildpack -c './bin/grafana-server web' -m 64m
> ```