From: Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [tpmdd-devel] [PATCH] tpm: remove unneeded include of actbl2.h
Date: Mon, 4 Jan 2016 13:11:26 -0700
Message-ID: <20160104201126.GA6098@cantor.redhat.com>
References: <1451935183-2514-1-git-send-email-jsnitsel@redhat.com>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1451935183-2514-1-git-send-email-jsnitsel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tpmdd-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, peterhuewe@gmx.de, tpmdd@selhorst.net, jarkko.sakkinen@linux.intel.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon Jan 04 16, Jerry Snitselaar wrote:
>tpm_tis.c already gets actbl2.h via linux/acpi.h -> acpi/acpi.h ->
>acpi/actbl.h -> acpi/actbl2.h, so the direct include in tpm_tis.c
>is not needed.
>
>Signed-off-by: Jerry Snitselaar <jsnitsel@redhat.com>
>---
>
>Jarrko, this is a trivial thing I noticed while doing some work.
>Not sure if you guys care, but thought I'd send it in anyways.
>
> drivers/char/tpm/tpm_tis.c | 1 -
> 1 file changed, 1 deletion(-)
>
>diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>index 65f7eec..461d486 100644
>--- a/drivers/char/tpm/tpm_tis.c
>+++ b/drivers/char/tpm/tpm_tis.c
>@@ -28,7 +28,6 @@
> #include <linux/wait.h>
> #include <linux/acpi.h>
> #include <linux/freezer.h>
>-#include <acpi/actbl2.h>
> #include "tpm.h"
>
> enum tis_access {
>-- 
>2.6.1
>

Not sure what happened, but it doesn't look like it CC'd Jarkko even
though it shows it in the git send-email output. Adding the other
maintainers as well.

	0001-tpm-remove-unneeded-include-of-actbl2.h.patch

	From: Jerry Snitselaar <jsnitsel@redhat.com>
	To: tpmdd-devel@lists.sourceforge.net
	Cc: linux-kernel@vger.kernel.org,
		jarkko.sakkinen@linux.intel.com
	Subject: [PATCH] tpm: remove unneeded include of actbl2.h
	Date: Mon,  4 Jan 2016 12:19:43 -0700
	Message-Id: <1451935183-2514-1-git-send-email-jsnitsel@redhat.com>
	X-Mailer: git-send-email 2.6.1

	Send this email? ([y]es|[n]o|[q]uit|[a]ll): a
	OK. Log says:
	Server: smtp.corp.redhat.com
	MAIL FROM:<jsnitsel@redhat.com>
	RCPT TO:<tpmdd-devel@lists.sourceforge.net>
	RCPT TO:<linux-kernel@vger.kernel.org>
	RCPT TO:<jarkko.sakkinen@linux.intel.com>
	From: Jerry Snitselaar <jsnitsel@redhat.com>
	To: tpmdd-devel@lists.sourceforge.net
	Cc: linux-kernel@vger.kernel.org,
		jarkko.sakkinen@linux.intel.com
	Subject: [PATCH] tpm: remove unneeded include of actbl2.h
	Date: Mon,  4 Jan 2016 12:19:43 -0700
	Message-Id: <1451935183-2514-1-git-send-email-jsnitsel@redhat.com>
	X-Mailer: git-send-email 2.6.1

	Result: 250 2.0.0 u04JJkA6027832 Message accepted for delivery
