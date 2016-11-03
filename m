From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 3/3] tpm: move documentation under
	Documentation/security
Date: Thu,  3 Nov 2016 17:57:52 -0600
Message-ID: <20161103235752.19256-4-jarkko.sakkinen@linux.intel.com>
References: <20161103235752.19256-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20161103235752.19256-1-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

In order too make Documentation root directory cleaner move the tpm
directory under Documentation/security.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 Documentation/index.rst                             | 2 +-
 Documentation/security/index.rst                    | 7 +++++++
 Documentation/{ => security}/tpm/index.rst          | 0
 Documentation/{ => security}/tpm/tpm_vtpm_proxy.rst | 0
 Documentation/{ => security}/tpm/xen-tpmfront.txt   | 0
 5 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/security/index.rst
 rename Documentation/{ => security}/tpm/index.rst (100%)
 rename Documentation/{ => security}/tpm/tpm_vtpm_proxy.rst (100%)
 rename Documentation/{ => security}/tpm/xen-tpmfront.txt (100%)

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 0058b65..b4c3034 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -19,7 +19,7 @@ Contents:
    media/dvb-drivers/index
    media/v4l-drivers/index
    gpu/index
-   tpm/index
+   security/index
 
 Indices and tables
 ==================
diff --git a/Documentation/security/index.rst b/Documentation/security/index.rst
new file mode 100644
index 0000000..9bae6bb
--- /dev/null
+++ b/Documentation/security/index.rst
@@ -0,0 +1,7 @@
+======================
+Security documentation
+======================
+
+.. toctree::
+
+   tpm/index
diff --git a/Documentation/tpm/index.rst b/Documentation/security/tpm/index.rst
similarity index 100%
rename from Documentation/tpm/index.rst
rename to Documentation/security/tpm/index.rst
diff --git a/Documentation/tpm/tpm_vtpm_proxy.rst b/Documentation/security/tpm/tpm_vtpm_proxy.rst
similarity index 100%
rename from Documentation/tpm/tpm_vtpm_proxy.rst
rename to Documentation/security/tpm/tpm_vtpm_proxy.rst
diff --git a/Documentation/tpm/xen-tpmfront.txt b/Documentation/security/tpm/xen-tpmfront.txt
similarity index 100%
rename from Documentation/tpm/xen-tpmfront.txt
rename to Documentation/security/tpm/xen-tpmfront.txt
-- 
2.9.3


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
