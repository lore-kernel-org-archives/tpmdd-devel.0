From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2 2/4] tpm: define __wait_for_tpm_stat to specify
 variable polling sleep time
Date: Fri, 15 Sep 2017 08:20:43 -0700
Message-ID: <20170915152043.2qr7ow4pbmrfnzt3@linux.intel.com>
References: <20170906125643.5070-1-nayna@linux.vnet.ibm.com>
 <20170906125643.5070-3-nayna@linux.vnet.ibm.com>
 <20170913005823.n7oqknkedlo22xe6@linux.intel.com>
 <20e706f4-d7c2-1d20-4268-129275ab3fc9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20e706f4-d7c2-1d20-4268-129275ab3fc9@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna Jain <nayna@linux.vnet.ibm.com>
Cc: tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de, tpmdd@selhorst.net, jgunthorpe@obsidianresearch.com, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ima-devel@lists.sourceforge.net, patrickc@us.ibm.com
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 15, 2017 at 06:07:26PM +0530, Nayna Jain wrote:
> 
> 
> On 09/13/2017 06:28 AM, Jarkko Sakkinen wrote:
> > On Wed, Sep 06, 2017 at 08:56:37AM -0400, Nayna Jain wrote:
> > > The existing wait_for_tpm_stat() checks the chip status before
> > > sleeping for 5 msec in a polling loop.  For some functions although
> > > the status isn't ready immediately, the status returns extremely
> > > quickly. Waiting for 5 msec causes an unnecessary delay. An
> > > example is the send() call in the tpms_tis driver.
> > > 
> > > This patch defines __wait_for_tpm_stat(), allowing the caller
> > > to specify the polling sleep timeout value within the loop.
> > > The existing wait_for_tpm_stat() becomes a wrapper for this
> > > function.
> > > 
> > > After this change, performance on a TPM 1.2 with an 8 byte
> > > burstcount for 1000 extends improved from ~14sec to ~10sec.
> > > 
> > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > Please get rid of wait_for_tpm_stat() rather than further making it more
> > complex. It's hardware specific stuff. This function should not exist in
> > tpm-interface.c.
> 
> I think I didn't understand the meaning of "get rid of wait_for_tpm_stat()".
> Do you mean to take care of it in driver specific file ?
> Can you please elaborate it ?
> 
> Thanks & Regards,
>     - Nayna

It's not a generic function. It's used only in tpm_tis and tpm-xenfront.
They should have their owen private functions for this. Here the sharing
of code makes zero sense.

/Jarkko
