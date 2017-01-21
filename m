From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH RFC v3 5/5] tpm2: expose resource manager
 via    a device link /dev/tpms<n>
Date: Sat, 21 Jan 2017 11:28:55 -0800
Message-ID: <1485026935.26703.12.camel@HansenPartnership.com>
References: <20170116131215.28930-1-jarkko.sakkinen@linux.intel.com>
         <20170116131215.28930-6-jarkko.sakkinen@linux.intel.com>
         <1484751663.2717.10.camel@HansenPartnership.com>
         <20170119104922.vhgz4rxw6yzdrxqt@intel.com>
         <1484828380.3140.11.camel@HansenPartnership.com>
         <20170120133914.2wk43nteh2hh7n3c@intel.com>
         <20170120210522.glx4y4oui36oimld@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170120210522.glx4y4oui36oimld@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-01-20 at 23:05 +0200, Jarkko Sakkinen wrote:
> On Fri, Jan 20, 2017 at 03:39:14PM +0200, Jarkko Sakkinen wrote:
> > On Thu, Jan 19, 2017 at 07:19:40AM -0500, James Bottomley wrote:
> > > On Thu, 2017-01-19 at 12:49 +0200, Jarkko Sakkinen wrote:
> > > > On Wed, Jan 18, 2017 at 10:01:03AM -0500, James Bottomley
> > > > wrote:
> > > > > On Mon, 2017-01-16 at 15:12 +0200, Jarkko Sakkinen wrote:
> > > > > > From: James Bottomley <
> > > > > > James.Bottomley@HansenPartnership.com>
> > > > > > 
> > > > > > Currently the Resource Manager (RM) is not exposed to
> > > > > > userspace. 
> > > > > >  Make this exposure via a separate device, which can now be
> > > > > > opened multiple times because each read/write transaction
> > > > > > goes 
> > > > > > separately via the RM.
> > > > > > 
> > > > > > Concurrency is protected by the chip->tpm_mutex for each 
> > > > > > read/write transaction separately.  The TPM is cleared of
> > > > > > all 
> > > > > > transient objects by the time the mutex is dropped, so
> > > > > > there 
> > > > > > should be no interference between the kernel and userspace.
> > > > > 
> > > > > There's actually a missing kfree of context_buf on the
> > > > > tpms_release
> > > > > path as well.  This patch fixes it up.
> > > > 
> > > > Can you send me a fresh version of the whole patch so that I
> > > > can 
> > > > include to v4 that includes also changes that I requested in my
> > > > recent comments + all the fixes?
> > > 
> > > Sure, I think the attached is basically it
> > > 
> > > James
> > 
> > Thank you!
> 
> 'tabrm4' branch has been now rebased. It's now on top of master
> branch
> that contains Stefan's latest patch (min body length check) that I've
> reviewed and tested. It also contains your updated /dev/tpms patch.
> 
> I guess the 5 commits that are there now are such that we have fairly
> good consensus, don't we? If so, can I add your reviewed-by and
> tested-by to my commits and vice versa?

Did you actually test it?  It doesn't work for me.  The bisected fault
commit is this one (newly introduced into the tabrm4 branch)

commit 9b7f4252655228c8d0b86e1492cc7fb3feaa5686
Author: Stefan Berger <stefanb@linux.vnet.ibm.com>
Date:   Thu Jan 19 07:19:12 2017 -0500

    tpm: Check size of response before accessing data
 
The specific problem is that our min_rsp_length in
tpm_{load,save}_context includes a header size and the check this
introduces does the check is against the body size, meaning the load
fails because tpm_transmit_cmd thinks the response is too short.

The patch to fix this is below.

James

---
commit 480f2bb484f5a7e6100c6b0d1c79f72a05a0ca88
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Jan 21 11:26:24 2017 -0800

    fix tpm_transmit_cmd min response size problem

diff --git a/drivers/char/tpm/tpm2-space.c b/drivers/char/tpm/tpm2-space.c
index 4b5c714..3237d7c 100644
--- a/drivers/char/tpm/tpm2-space.c
+++ b/drivers/char/tpm/tpm2-space.c
@@ -53,7 +53,7 @@ static int tpm2_load_context(struct tpm_chip *chip, u8 *buf,
 	tpm_buf_append(&tbuf, &buf[*offset], body_size);
 
 	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE,
-			      TPM_HEADER_SIZE + 4, TPM_TRANSMIT_UNLOCKED, "load context");
+			      4, TPM_TRANSMIT_UNLOCKED, "load context");
 	if ((rc & TPM2_RC_HANDLE) == TPM2_RC_HANDLE) {
 		rc = -ENOENT;
 		tpm_buf_destroy(&tbuf);
@@ -89,7 +89,7 @@ static int tpm2_save_context(struct tpm_chip *chip, u32 handle, u8 *buf,
 
 	tpm_buf_append_u32(&tbuf, handle);
 
-	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, TPM_HEADER_SIZE,
+	rc = tpm_transmit_cmd(chip, NULL, tbuf.data, PAGE_SIZE, 0,
 			      TPM_TRANSMIT_UNLOCKED, NULL);
 	if (rc < 0) {
 		dev_warn(&chip->dev, "%s: saving failed with a system error %d\n",
