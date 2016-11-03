From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 2/3] tpm: transition tpm_vtpm_proxy documentation to the Sphinx
Date: Thu,  3 Nov 2016 17:57:51 -0600
Message-ID: <20161103235752.19256-3-jarkko.sakkinen@linux.intel.com>
References: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
Sender: linux-doc-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Stefan Berger <stefanb@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Transitioned the tpm_vtpm_proxy documentation to the Sphinx
infrastructure and removed parts from the documentation that are easier
to pull from the sources. Restructured vtpm_proxy.h and tpm_vtpm_proxy.c
to be compatible with this approach and wrote associated documentation
comments.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/index.rst                            |  1 +
 Documentation/tpm/index.rst                        |  7 +++
 .../tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} | 55 +++++++---------------
 3 files changed, 25 insertions(+), 38 deletions(-)
 create mode 100644 Documentation/tpm/index.rst
 rename Documentation/tpm/{tpm_vtpm_proxy.txt => tpm_vtpm_proxy.rst} (53%)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index e0fc729..0058b65 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -19,6 +19,7 @@ Contents:
    media/dvb-drivers/index
    media/v4l-drivers/index
    gpu/index
+   tpm/index
 
 Indices and tables
 ==================
diff --git a/Documentation/tpm/index.rst b/Documentation/tpm/index.rst
new file mode 100644
index 0000000..af77a7b
--- /dev/null
+++ b/Documentation/tpm/index.rst
@@ -0,0 +1,7 @@
+=====================================
+Trusted Platform Module documentation
+=====================================
+
+.. toctree::
+
+   tpm_vtpm_proxy
diff --git a/Documentation/tpm/tpm_vtpm_proxy.txt b/Documentation/tpm/tpm_vtpm_proxy.rst
similarity index 53%
rename from Documentation/tpm/tpm_vtpm_proxy.txt
rename to Documentation/tpm/tpm_vtpm_proxy.rst
index 30d1902..ea08e76 100644
--- a/Documentation/tpm/tpm_vtpm_proxy.txt
+++ b/Documentation/tpm/tpm_vtpm_proxy.rst
@@ -1,71 +1,50 @@
+=============================================
 Virtual TPM Proxy Driver for Linux Containers
+=============================================
 
-Authors: Stefan Berger (IBM)
+| Authors:
+| Stefan Berger <stefanb@linux.vnet.ibm.com>
 
 This document describes the virtual Trusted Platform Module (vTPM)
 proxy device driver for Linux containers.
 
-INTRODUCTION
-------------
+Introduction
+============
 
 The goal of this work is to provide TPM functionality to each Linux
 container. This allows programs to interact with a TPM in a container
 the same way they interact with a TPM on the physical system. Each
 container gets its own unique, emulated, software TPM.
 
-
-DESIGN
-------
+Design
+======
 
 To make an emulated software TPM available to each container, the container
 management stack needs to create a device pair consisting of a client TPM
-character device /dev/tpmX (with X=0,1,2...) and a 'server side' file
+character device ``/dev/tpmX`` (with X=0,1,2...) and a 'server side' file
 descriptor. The former is moved into the container by creating a character
 device with the appropriate major and minor numbers while the file descriptor
 is passed to the TPM emulator. Software inside the container can then send
 TPM commands using the character device and the emulator will receive the
 commands via the file descriptor and use it for sending back responses.
 
-To support this, the virtual TPM proxy driver provides a device /dev/vtpmx
+To support this, the virtual TPM proxy driver provides a device ``/dev/vtpmx``
 that is used to create device pairs using an ioctl. The ioctl takes as
 an input flags for configuring the device. The flags  for example indicate
 whether TPM 1.2 or TPM 2 functionality is supported by the TPM emulator.
 The result of the ioctl are the file descriptor for the 'server side'
 as well as the major and minor numbers of the character device that was created.
-Besides that the number of the TPM character device is return. If for
-example /dev/tpm10 was created, the number (dev_num) 10 is returned.
-
-The following is the data structure of the TPM_PROXY_IOC_NEW_DEV ioctl:
-
-struct vtpm_proxy_new_dev {
-	__u32 flags;         /* input */
-	__u32 tpm_num;       /* output */
-	__u32 fd;            /* output */
-	__u32 major;         /* output */
-	__u32 minor;         /* output */
-};
-
-Note that if unsupported flags are passed to the device driver, the ioctl will
-fail and errno will be set to EOPNOTSUPP. Similarly, if an unsupported ioctl is
-called on the device driver, the ioctl will fail and errno will be set to
-ENOTTY.
-
-See /usr/include/linux/vtpm_proxy.h for definitions related to the public interface
-of this vTPM device driver.
+Besides that the number of the TPM character device is returned. If for
+example ``/dev/tpm10`` was created, the number (``dev_num``) 10 is returned.
 
 Once the device has been created, the driver will immediately try to talk
 to the TPM. All commands from the driver can be read from the file descriptor
 returned by the ioctl. The commands should be responded to immediately.
 
-Depending on the version of TPM the following commands will be sent by the
-driver:
+UAPI
+====
 
-- TPM 1.2:
-  - the driver will send a TPM_Startup command to the TPM emulator
-  - the driver will send commands to read the command durations and
-    interface timeouts from the TPM emulator
-- TPM 2:
-  - the driver will send a TPM2_Startup command to the TPM emulator
+.. kernel-doc:: include/uapi/linux/vtpm_proxy.h
 
-The TPM device /dev/tpmX will only appear if all of the relevant commands
-were responded to properly.
+.. kernel-doc:: drivers/char/tpm/tpm_vtpm_proxy.c
+   :functions: vtpmx_ioc_new_dev
-- 
2.9.3

