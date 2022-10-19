DROP TABLE "host_info" CASCADE;
DROP TABLE "host_usage" CASCADE;
CREATE TABLE PUBLIC.host_info
  (
     id               SERIAL,
     hostname         VARCHAR(300) NOT NULL,
     cpu_number       INT     NOT NULL,
     cpu_architecture VARCHAR(10) NOT NULL,
     cpu_model        VARCHAR(30) NOT NULL,
     cpu_mhz          DECIMAL(7,3) NOT NULL,
     L2_cache          INT  NOT NULL,
     total_mem         INT NOT NULL,
     "timestamp"         TIMESTAMP NOT NULL,
     PRIMARY KEY(id)

  );
CREATE TABLE PUBLIC.host_usage
  (
     "timestamp"    TIMESTAMP NOT NULL,
     host_id        SERIAL,
     memory_free    INT     NOT NULL,
     cpu_idle       SMALLINT     NOT NULL,
     cpu_kernel     SMALLINT     NOT NULL,
     disk_io        SMALLINT     NOT NULL,
     disk_available INT     NOT NULL,
     FOREIGN KEY (host_id) REFERENCES PUBLIC.host_info(id) ON DELETE CASCADE

  );