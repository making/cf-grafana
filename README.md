## Grafana on Cloud Foundry


### How to deploy Grafana to Cloud Foundry


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

> If you use free `spark` plan of `cleardb` service, you'll get a lot of errors because the number of connections allowed by ClearDb is only `4`. You can reload a lot and sometimes get correct responses. 
>
> If you don't need to persist dashboards and users, you can use default sqlite3 as follows. This is much better experience than free ClearDB though everything in the instance will disappear when you restart the application.
>
> ```
> sed -i -e 's|^http_port = 3000$|http_port = 8080|' ./conf/defaults.ini
> cf push my-grafana -b binary_buildpack -c './bin/grafana-server web' -m 64m
> ```

### (Optional) How to deploy Prometheus to Cloud Foundry

```
wget https://github.com/prometheus/prometheus/releases/download/v1.7.1/prometheus-1.7.1.linux-amd64.tar.gz
tar -zxvf prometheus-1.7.1.linux-amd64.tar.gz
cd prometheus-1.7.1.linux-amd64
sed -i -e 's|localhost:9090|localhost:8080|' prometheus.yml
# and add scrape_configs for your exporters
cf push my-prom -b binary_buildpack -c './prometheus -web.listen-address=:8080' -m 64m
```

Go to https://my-prom.cfapps.io

This instance uses local storage, so all metrics will be reset when it is restarted.
