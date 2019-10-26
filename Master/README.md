# The master computer

The master computer that controls the complete cloud is not a worker node. 

It is a probably client pc with a small sql server database that coordinates everything.
(Needless to say that you should probably set up this one first.)

  - [ ] Install any version of Microsoft Sql Server you like. Sql Server Express is absolutely fine.
  - [ ] Install a version of Microsoft Sql Server Management Studio
  - [ ] Create a new database using the database.sql script in this folder. You can name the database any way you want. I will use the name "MicroCloud" for my setup.
    - [ ] set the recovery model to simple (the workers will later connect and update several information in a tight interval, we do not want the database size to explode on us...)

  - [ ] install `https://www.microsoft.com/de-DE/download/details.aspx?id=45520` for testing purposes and maybe support to be able to connect to your nodes using visual tooling

*(to be continued)*