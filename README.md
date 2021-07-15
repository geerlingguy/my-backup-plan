# My Backup Plan

This repository contains the scripts and explanation behind my personal backup strategy.

Every backup plan is unique, based on your risk assessment, the importance of the data being backed up, and budget (both in time and money).

This is mine, and I figured I'd go ahead and document everything publicly, because so many people ask about it.

Having a solid and multi-tiered backup plan gives you peace of mind and the freedom to not feel tied to any particular computer or 'sacred and precious backup drive' that has all your data stored on it.

I follow a variant of the 3-2-1 backup strategy, and have _at least_:

```
3 Copies of all my data
2 Copies on different storage media
1 Offsite copy
```

And for some of my data (like the contents of my Dropbox or iCloud Photos Library) I have 4 or 5 copies of the data!

## Backup Strategy

TODO: Go over entire plan, top-to-bottom, including:

  - iCloud Photo Library
  - iCloud Music Library + iTunes Match
  - Dropbox
  - Local NAS
    - [NAS Settings backup]()
  - Local Time Machine
  - Amazon S3 Glacier Deep Archive
  - Open Source repositories on GitHub
  - Pi-hole config

## `main.yml` - Ansible playbook to configure my Backup Pi

There's an Ansible playbook that installs rclone, configures shared filesystem mounts, and configures a backup cron job. To run the playbook:

  1. Make sure you have Ansible installed.
  2. Copy `example.inventory.ini` to `inventory.ini` and `example.config.yml` to `config.yml`, and modify them according to your needs.
  3. Run `ansible-galaxy install -r requirements.yml`
  4. Run the playbook: `ansible-playbook main.yml`

### Manual `rclone` setup

For security purposes, I don't keep the entire `rclone` config in this repository. I could via Ansible Vault, but I don't. Sue me.

So after running the playbook, for `rclone` to actually work, you'll need to do the following manually, one time:

Run `rclone config` following the [S3 setup instructions](https://rclone.org/s3/#amazon-s3).

  - Set the remote name to `personal`.
  - Set the type of storage to `s3`.
  - Set the S3 provider to `AWS`.
  - For access credentials, I created a limited `rclone` user in AWS Console and have an access key set up for that user.
  - Set the region to `us-east-1`.
  - Set the ACL to `private`.
  - Set the storage class to `DEEP_ARCHIVE`.

Do all of this as the `pi` user (or whatever user you're going to configure to run the backups).

## `backup.sh` - Rclone to S3 Glacier Deep Archive

You can manually run `backup.sh` the first time and watch it do its magic:

```
pi@backup:~ $ ./backup.sh 
```

The initial backup could take a while—mine took over two weeks :)

Caveats with Glacier Deep Archive:

  1. You can't easily move objects around inside the bucket. So don't just dump stuff into Deep Archive that's going to move around a lot, especially very large files that would need a re-upload or to be downloaded then moved.
  2. Retrieval takes time—at least 12 hours _just to restore an object to your Bucket so you can start downloading it_. There is no 'expedited' option with Deep Archive.

## Retriving content from S3 Glacier Deep Archive

**For individual file retrieval**, see: [Retrieving individual files from S3 Glacier Deep Archive using AWS CLI](https://www.jeffgeerling.com/blog/2021/retrieving-individual-files-s3-glacier-deep-archive-using-aws-cli)

**For entire directory restore**, see: TODO.

## Backup Security

TODO: Explain how I keep my backup data secure and free from prying eyes. Also the different 'tiers' of data (in terms of importance of things like encryption).

## Author

This project is maintained by [Jeff Geerling](https://www.jeffgeerling.com), author of [Ansible for DevOps](https://www.ansiblefordevops.com).
