## Домашнее задание №4 - Развернуть InnoDB или PXC кластер

> развернуть InnoDB или PXC кластер
>
> Цель:
>
> Перевести базу вебпроекта на один из вариантов кластера MySQL

Был выбран InnoDB кластер.

---
Для разворачивания самого InnoDB-кластера написал ansible роль innodb_cluster, которая:

1. Устанавливает из репозитория dev.mysql.com пакеты mysql-community-server и mysql-shell
2. Создаёт конфигурационный файл /etc/my.cnf из шаблона [my.cnf](ansible/roles/innodb_cluster/templates/my.cnf). 
3. Включает переменную SELinux mysql_connect_any (https://dba.stackexchange.com/questions/273847/mysql-innodb-cluster). Иначе не работает group_replication.
4. Включает и запускает systemd-сервис mysqld
5. Извлекает временный пароль от root пользователя mysql из /var/log/mysqld.log. Используя его, устанавливает новый пароль, определённый в переменной.
6. Создаёт пользователя clusteradmin
7. Создаёт на первой ноде кластер скрипт bootstrap_cluster.js из шаблона [bootstrap_cluster.js.j2](ansible/roles/innodb_cluster/templates/bootstrap_cluster.js.j2)
8. Запускает полученный скрипт при помощи mysqlsh на первой ноде кластера. Например для кластера из трёх нод, данный скрипт выполняет:
```js
  shell.connect('clusteradmin@db-0', 'InnoD6P!ssw0rd');
  var cluster = dba.createCluster('innodbcluster');
  cluster.addInstance('clusteradmin@db-1:3306', {recoveryMethod: 'clone'})  
  cluster.addInstance('clusteradmin@db-2:3306', {recoveryMethod: 'clone'})  
  cluster.switchToMultiPrimaryMode()
```

---
Для использования получившегося кластера серверами приложений была написана роль mysql_router, которая:

1. Устанавливает из репозитория dev.mysql.com пакеты mysql-router и mysql (требуется для процедуры создания и импорта дампа dump.sql)
2. Создаёт директорию для сокета mysql.sock (по умолчанию /var/lib/mysql/). Для возможности приложения (php-fpm) использовать данный сокет важно установить SELinux-контекст mysqld_db_t.
3. Выполняется команда mysqlrouter --boostrap с использованием УЗ clusteradmin:
```sh
    mysqlrouter
    --bootstrap 'clusteradmin:InnoD6P!ssw0rd@db-0'
    --disable-rest
    --conf-skip-tcp
    --conf-use-sockets
    --conf-bind-address {{ mysqlrouter_bind_address }}
    --connect-timeout {{ mysqlrouter_connect_timeout }}
    --read-timeout {{ mysqlrouter_read_timeout }}
    --conf-use-gr-notifications
    --user mysqlrouter
    --force
```
4. Из полученного в результате выполнения команды конфигурационного файла /etc/mysqlrouter/mysqlrouter.conf удаляются неиспользуемые секции routing:innodbcluster_ro, routing:innodbcluster_x_rw и routing:innodbcluster_x_ro
5. В /etc/mysqlrouter/mysqlrouter.conf изменяется месторасположение сокета (на /var/run/mysqlrouter/mysql.sock). По умолчанию при запуске mysqlrouter --boostrap генерируется конфигурационный файл с расположением сокетов в /tmp. Это не работает, т.к. для systemd-сервисов php-fpm и mysqlrouter установлен параметр PrivateTmp=true.
6. Включается и запускается systemd-сервис mysqlrouter

---
В результате применения данных ролей, на каждом сервере приложений становится доступным сокет /var/run/mysqlrouter/mysql.sock. При использовании данного сокета, приложение посредством установленного на сервере приложений mysqlrouter взаимодействует с кластером серверов mysql (InnoDB).

## Проверка работоспособности:
После запуска данного terraform-модуля:
```sh
$ yc compute instance list
+----------------------+---------+---------------+---------+--------------+----------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  | EXTERNAL IP  |  INTERNAL IP   |
+----------------------+---------+---------------+---------+--------------+----------------+
| fhm1g9lnmo4ucbtov9av | app-1   | ru-central1-a | RUNNING |              | 192.168.11.7   |
| fhm59eki52k2v9p7vn9f | db-1    | ru-central1-a | RUNNING |              | 192.168.11.25  |
| fhm7n7dgn26s832svm67 | nginx-0 | ru-central1-a | RUNNING |              | 192.168.11.10  |
| fhmdng5le99ku1bgjmb1 | app-0   | ru-central1-a | RUNNING |              | 192.168.11.22  |
| fhmevp1k62oka34mlc0h | nginx-1 | ru-central1-a | RUNNING |              | 192.168.11.32  |
| fhmnm4gbk94e38cuhcfk | db-0    | ru-central1-a | RUNNING |              | 192.168.11.31  |
| fhmr3aatglgv8m0bac5d | db-2    | ru-central1-a | RUNNING |              | 192.168.11.18  |
| fhmv2r2rcdl06haunisi | bastion | ru-central1-a | RUNNING | 62.84.113.24 | 192.168.11.254 |
+----------------------+---------+---------------+---------+--------------+----------------+
```

dba.getCluster().status() на одном из db-серверов возвращает:
```json
{
    "clusterName": "innodbcluster", 
    "defaultReplicaSet": {
        "name": "default", 
        "ssl": "REQUIRED", 
        "status": "OK", 
        "statusText": "Cluster is ONLINE and can tolerate up to ONE failure.", 
        "topology": {
            "db-0.ru-central1.internal:3306": {
                "address": "db-0.ru-central1.internal:3306", 
                "memberRole": "PRIMARY", 
                "mode": "R/W", 
                "readReplicas": {}, 
                "replicationLag": null, 
                "role": "HA", 
                "status": "ONLINE", 
                "version": "8.0.26"
            }, 
            "db-1.ru-central1.internal:3306": {
                "address": "db-1.ru-central1.internal:3306", 
                "memberRole": "PRIMARY", 
                "mode": "R/W", 
                "readReplicas": {}, 
                "replicationLag": null, 
                "role": "HA", 
                "status": "ONLINE", 
                "version": "8.0.26"
            }, 
            "db-2.ru-central1.internal:3306": {
                "address": "db-2.ru-central1.internal:3306", 
                "memberRole": "PRIMARY", 
                "mode": "R/W", 
                "readReplicas": {}, 
                "replicationLag": null, 
                "role": "HA", 
                "status": "ONLINE", 
                "version": "8.0.26"
            }
        }, 
        "topologyMode": "Multi-Primary"
    }, 
    "groupInformationSourceMember": "db-0.ru-central1.internal:3306"
}
```

Содержимое /var/lib/mysqlrouter/state.json на одном из app-серверов:
```json
{
    "metadata-cache": {
        "group-replication-id": "086e9659-0e37-11ec-8845-d00d17b120ba",
        "cluster-metadata-servers": [
            "mysql://db-0.ru-central1.internal:3306",
            "mysql://db-1.ru-central1.internal:3306",
            "mysql://db-2.ru-central1.internal:3306"
        ]
    },
    "version": "1.0.0"
}
```

SQL-запросы выполняются через сокет на одном из app-серверов:
```sh
[root@app-0 ~]$ mysql -u clusteradmin --password='InnoD6P!ssw0rd' --socket=/var/run/mysqlrouter/mysql.sock -e 'SHOW DATABASES;'
mysql: [Warning] Using a password on the command line interface can be insecure.
+-------------------------------+
| Database                      |
+-------------------------------+
| information_schema            |
| mysql                         |
| mysql_innodb_cluster_metadata |
| performance_schema            |
| sys                           |
| wordpress                     |
+-------------------------------+
```

---
После отключения одного из db-серверов:
```sh
$ yc compute instance stop db-0
done (13s)
$ yc compute instance list
+----------------------+---------+---------------+---------+--------------+----------------+
|          ID          |  NAME   |    ZONE ID    | STATUS  | EXTERNAL IP  |  INTERNAL IP   |
+----------------------+---------+---------------+---------+--------------+----------------+
| fhm1g9lnmo4ucbtov9av | app-1   | ru-central1-a | RUNNING |              | 192.168.11.7   |
| fhm59eki52k2v9p7vn9f | db-1    | ru-central1-a | RUNNING |              | 192.168.11.25  |
| fhm7n7dgn26s832svm67 | nginx-0 | ru-central1-a | RUNNING |              | 192.168.11.10  |
| fhmdng5le99ku1bgjmb1 | app-0   | ru-central1-a | RUNNING |              | 192.168.11.22  |
| fhmevp1k62oka34mlc0h | nginx-1 | ru-central1-a | RUNNING |              | 192.168.11.32  |
| fhmnm4gbk94e38cuhcfk | db-0    | ru-central1-a | STOPPED |              | 192.168.11.31  |
| fhmr3aatglgv8m0bac5d | db-2    | ru-central1-a | RUNNING |              | 192.168.11.18  |
| fhmv2r2rcdl06haunisi | bastion | ru-central1-a | RUNNING | 62.84.113.24 | 192.168.11.254 |
+----------------------+---------+---------------+---------+--------------+----------------+
```

dba.getCluster().status():
```json
{
    "clusterName": "innodbcluster", 
    "defaultReplicaSet": {
        "name": "default", 
        "ssl": "REQUIRED", 
        "status": "OK_NO_TOLERANCE", 
        "statusText": "Cluster is NOT tolerant to any failures. 1 member is not active.", 
        "topology": {
            "db-0.ru-central1.internal:3306": {
                "address": "db-0.ru-central1.internal:3306", 
                "memberRole": "SECONDARY", 
                "mode": "n/a", 
                "readReplicas": {}, 
                "role": "HA", 
                "shellConnectError": "MySQL Error 2003 (HY000): Can't connect to MySQL server on 'db-0.ru-central1.internal:3306' (110)", 
                "status": "(MISSING)"
            }, 
            "db-1.ru-central1.internal:3306": {
                "address": "db-1.ru-central1.internal:3306", 
                "memberRole": "PRIMARY", 
                "mode": "R/W", 
                "readReplicas": {}, 
                "replicationLag": null, 
                "role": "HA", 
                "status": "ONLINE", 
                "version": "8.0.26"
            }, 
            "db-2.ru-central1.internal:3306": {
                "address": "db-2.ru-central1.internal:3306", 
                "memberRole": "PRIMARY", 
                "mode": "R/W", 
                "readReplicas": {}, 
                "replicationLag": null, 
                "role": "HA", 
                "status": "ONLINE", 
                "version": "8.0.26"
            }
        }, 
        "topologyMode": "Multi-Primary"
    }, 
    "groupInformationSourceMember": "db-1.ru-central1.internal:3306"
}
```

/var/lib/mysqlrouter/state.json:
```json
{    "metadata-cache": {
        "group-replication-id": "086e9659-0e37-11ec-8845-d00d17b120ba",
        "cluster-metadata-servers": [
            "mysql://db-0.ru-central1.internal:3306",
            "mysql://db-1.ru-central1.internal:3306",
            "mysql://db-2.ru-central1.internal:3306"
        ]
    },
    "version": "1.0.0"
}
```

SQL-запросы продолжают работать:
```sh
[root@app-0 ~]$ mysql -u clusteradmin --password='InnoD6P!ssw0rd' --socket=/var/run/mysqlrouter/mysql.sock -e 'SHOW DATABASES;'
mysql: [Warning] Using a password on the command line interface can be insecure.
+-------------------------------+
| Database                      |
+-------------------------------+
| information_schema            |
| mysql                         |
| mysql_innodb_cluster_metadata |
| performance_schema            |
| sys                           |
| wordpress                     |
+-------------------------------+
```

В лог-файлах mysqlrouter:
```log
2021-09-05 15:33:23 metadata_cache ERROR [7fcfbc280700] Failed to connect to metadata server f911c5cd-0e36-11ec-bcf7-d00d17b120ba
2021-09-05 15:33:33 metadata_cache WARNING [7fcfbc280700] While updating metadata, could not establish a connection to replicaset 'default' through db-0.ru-central1.internal:3306
2021-09-05 15:33:33 metadata_cache WARNING [7fcfbc280700] Member db-0.ru-central1.internal:3306 (f911c5cd-0e36-11ec-bcf7-d00d17b120ba) defined in metadata not found in actual replicaset
2021-09-05 15:33:44 metadata_cache WARNING [7fcfbc280700] Failed connecting with Metadata Server db-0.ru-central1.internal:3306: Can't connect to MySQL server on 'db-0.ru-central1.internal:3306' (110) (2003)
```

Само приложение (wordpress) использующее ДБ, продолжает стабильно работать:
```sh
for i in {1..200}; do curl -o /dev/null -s -w "%{http_code}\n" -k https://otus.internal/index.php?health_check=true; done
200
200
200
...
```

## Общее описание модуля terraform

Этот модуль terraform создаёт:
* 1 хост bastion (используется как ssh-джампхост и NAT для соединений от остальных серверов в Интернет)
* Указанное в переменной db_count количество серверов с ролью innodb_cluster
* Указанное в переменной app_count количество серверов с ролями php_fpm, wordpress и mysql_router
* Указанное в переменной nginx_count количество серверов с ролями nginx и wordpress
* 1 балансировщик нагрузки, распределяющий обращения между серверами с nginx

Особенности:
* Реализован TLS для серверов с nginx, в качестве корневого сертификата для целей демонстрации используются самоподписанный, из директории cfssl
* Для всех серверов кроме bastion используется ОС CentOS 8 Stream
* Устанавливаются все доступные обновления для всех серверов
* Реализовано создание резервной копии БД wordpress при terraform destroy (плейбук playbook-backup.yaml), и восстановление из него при установке (роль wordpress_mysqldb). БД с уже сконфигурированным wordpress для демонстрации есть в репозитории - dump.sql

Примечания:
* Предполагается использование ssh agent forwading при подключении к bastion.
* Сам wordpress доступен по https://otus.internal (terraform добавляет соответствующую запись в /etc/hosts)
* Учётные данные администратора wordpress (http://otus.internal/wp-admin/) в dump.sql:
  * Username: otus
  * Password: vyf2uxnnZhWfjeX4ty

## Требования

Несколько не входящих в стандартную поставку коллекций ansible:
```sh
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.general
ansible-galaxy collection install community.mysql
ansible-galaxy collection install community.crypto
```

## Обязательные переменные

Следующие переменные обязательно должны быть определены для terraform:

### <a name="input_cloud_id"></a> [cloud\_id](#input\_cloud\_id)

Описание: The ID of the yandex cloud

Type: `string`

### <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id)

Описание: The ID of the folder in the yandex cloud to operate under

Type: `string`

### <a name="input_ssh_pubkey"></a> [ssh\_pubkey](#input\_ssh\_pubkey)

Описание: SSH public key

Type: `string`


## Опицональные переменные

Следующие переменные terraform опицональны (есть значения по умолчанию):

### <a name="input_app_count"></a> [app\_count](#input\_app\_count)

Description: Count of app node instances

Type: `number`

Default: `2`

### <a name="input_image_id"></a> [image\_id](#input\_image\_id)

Description: The ID of the existing disk, default is CentOS 8 Stream

Type: `string`

Default: `"fd8hnbln4tn9k0823esa"`

### <a name="input_nginx_count"></a> [nginx\_count](#input\_nginx\_count)

Description: Count of nginx node instances

Type: `number`

Default: `2`

### <a name="input_username"></a> [username](#input\_username)

Description: Username to use for ssh

Type: `string`

Default: `"otus"`

### <a name="input_yc_service_account_key_file"></a> [yc\_service\_account\_key\_file](#input\_yc\_service\_account\_key\_file)

Description: (Optional) Contains either a path to or the contents of the Service Account file in JSON format

Type: `string`

Default: `null`

### <a name="input_yc_token"></a> [yc\_token](#input\_yc\_token)

Description: (Optional) Security token or IAM token used for authentication in Yandex.Cloud

Type: `string`

Default: `null`

### <a name="input_zone"></a> [zone](#input\_zone)

Description: Yandex.Cloud availability zone

Type: `string`

Default: `"ru-central1-a"`

## Outputs

The following outputs are exported:

### <a name="output_external_ip_address_bastion"></a> [external\_ip\_address\_bastion](#output\_external\_ip\_address\_bastion)

Description: External IP of ready bastion instance

### <a name="output_external_ip_address_lb"></a> [external\_ip\_address\_lb](#output\_external\_ip\_address\_lb)

Description: External IP of ready load balancer
<!-- END_TF_DOCS -->
