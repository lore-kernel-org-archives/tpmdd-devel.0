From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Sun, 22 Jan 2017 10:48:12 -0800
Message-ID: <1485110892.2504.12.camel@HansenPartnership.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
         <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
         <1484751663.2717.10.camel@HansenPartnership.com>
         <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
         <1484828380.3140.11.camel@HansenPartnership.com>
         <20170120133914.2wk43nteh2hh7n3c@intel.com>
         <20170120210522.glx4y4oui36oimld@intel.com>
         <1485107342.2504.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1485107342.2504.7.camel@HansenPartnership.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Sun, 2017-01-22 at 09:49 -0800, James Bottomley wrote:
> On Fri, 2017-01-20 at 23:05 +0200, Jarkko Sakkinen wrote:
> > 'tabrm4' branch has been now rebased. It's now on top of master
> > branch that contains Stefan's latest patch (min body length check) 
> > that I've reviewed and tested. It also contains your updated
> > /dev/tpms patch.
> > 
> > I guess the 5 commits that are there now are such that we have 
> > fairly good consensus, don't we? If so, can I add your reviewed-by 
> > and tested-by to my commits and vice versa?
> 
> We're still failing my test_transients.  This is the full python of 
> the test case:
> 
> 
>     def test_transients(self):
>         k = self.open_transients()
>         self.c.flush_context(k[0])
>         self.c.change_auth(self.c.SRK, k[1], None, pwd1)
>         ...
> 
> It's failing at self.c.flush_context(k[0]) with TPM_RC_VALUE.  It's 
> the same problem Ken complained about: TPM2_FlushContext doesn't have 
> a declared handle area so we don't translate the handle being sent
> down.  We have to fix this either by intercepting the flush and 
> manually translating the context, or by being dangerously clever and 
> marking flush as a command which takes one handle.

This is what the dangerously clever fix looks like.  With this and a
few other changes, my smoke tests now pass.

James

---

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index f54226d..d5517f1 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -1053,9 +1053,16 @@ int tpm2_auto_startup(struct tpm_chip *chip)
 		goto out;
 	}
 
-	for (i = 0; i < nr_commands; i++)
-		chip->cc_attrs_tbl[i] = be32_to_cpup(
-			(u32 *)&buf.data[TPM_HEADER_SIZE + 9 + 4 * i]);
+	for (i = 0; i < nr_commands; i++) {
+		u32 attr = be32_to_cpup((u32 *)&buf.data[TPM_HEADER_SIZE +
+							 9 + 4 * i]);
+		if ((attr & GENMASK(15,0)) == TPM2_CC_FLUSH_CONTEXT)
+			/* Warning: dangerous cleverness here.
+			 * Mark flush as taking a handle argument so
+			 * it gets correctly translated */
+			attr |= 1 << TPM2_CC_ATTR_CHANDLES;
+		chip->cc_attrs_tbl[i] = attr;
+	}
 
 	chip->nr_commands = nr_commands;
 	tpm_buf_destroy(&buf);
