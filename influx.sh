docker run --rm influxdb influxd config | sed -e 's/.*max-body-size.*/  max-body-size = 0/' > /var/tmp/influxdb/influxdb.conf
docker run -p 8083:8083 -p 8086:8086 -v /var/tmp/influxdb:/var/lib/influxdb -e INFLUXDB_ADMIN_ENABLED=true -v /var/tmp/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf:ro influxdb -config /etc/influxdb/influxdb.conf
# Create the DB
curl -X POST -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE mydb"

# Load the data
time curl -i -XPOST 'http://localhost:8086/write?db=mydb&p=us' -H 'Transfer-Encoding: chunked' -T dataset.influx
