From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm-dev-common: Reject too short writes
Date: Thu, 7 Sep 2017 19:46:56 +0300
Message-ID: <20170907164656.skq6624og7xlmg5z@linux.intel.com>
References: <20170904173642.5988-1-Alexander.Steffen@infineon.com>
 <20170906124233.qquzut5lyuri2buu@linux.intel.com>
 <20170906125033.32cwy27inzecfo3i@linux.intel.com>
 <f8ea7617d4da43439d59b30f4de63b87@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f8ea7617d4da43439d59b30f4de63b87@MUCSE603.infineon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander.Steffen@infineon.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Sep 06, 2017 at 02:19:28PM +0000, Alexander.Steffen@infineon.com wrote:
> > On Wed, Sep 06, 2017 at 03:42:33PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, Sep 04, 2017 at 07:36:42PM +0200, Alexander Steffen wrote:
> > > > tpm_transmit() does not offer an explicit interface to indicate the
> > > > number of valid bytes in the communication buffer. Instead, it
> > > > relies on the commandSize field in the TPM header that is encoded within
> > the buffer.
> > > > Therefore, ensure that a) enough data has been written to the
> > > > buffer, so that the commandSize field is present and b) the
> > > > commandSize field does not announce more data than has been written
> > to the buffer.
> > > >
> > > > This should have been fixed with CVE-2011-1161 long ago, but
> > > > apparently a correct version of that patch never made it into the kernel.
> > > >
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Alexander Steffen <Alexander.Steffen@infineon.com>
> > > > ---
> > > > v2:
> > > > - Moved all changes to tpm_common_write in a single patch.
> > > >
> > > >  drivers/char/tpm/tpm-dev-common.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/char/tpm/tpm-dev-common.c
> > > > b/drivers/char/tpm/tpm-dev-common.c
> > > > index 610638a..ac25574 100644
> > > > --- a/drivers/char/tpm/tpm-dev-common.c
> > > > +++ b/drivers/char/tpm/tpm-dev-common.c
> > > > @@ -99,7 +99,8 @@ ssize_t tpm_common_write(struct file *file, const
> > char __user *buf,
> > > >  	if (atomic_read(&priv->data_pending) != 0)
> > > >  		return -EBUSY;
> > > >
> > > > -	if (in_size > TPM_BUFSIZE)
> > > > +	if (in_size > sizeof(priv->data_buffer) || in_size < 6 ||
> > > > +	    in_size < be32_to_cpu(*((__be32 *) (buf + 2))))
> > > >  		return -E2BIG;
> > > >
> > > >  	mutex_lock(&priv->buffer_mutex);
> > > > --
> > > > 2.7.4
> > > >
> > >
> > > How did you test this change after you implemented it?
> > >
> > > Just thinking what to add to
> > > https://github.com/jsakkine-intel/tpm2-scripts
> 
> I already had test cases that failed with some of my TPMs under some circumstances. I'll try to come up with a concise description of what those tests do or send you a patch directly for your tests. GitHub pull requests are okay for that repository? (I already have one waiting there.)
> 
> > >
> > > /Jarkko
> > 
> > Just when I started to implement this that the bug fix itself does not have yet
> > the right semantics.
> > 
> > It should be just add a new check:
> > 
> > if (in_size != be32_to_cpu(*((__be32 *) (buf + 2))))
> > 	return -EINVAL;
> > 
> > The existing check is correct. This was missing. The reason for this is that we
> > process whatever is in the in_size bytes as a full command.
> 
> There are two problems with this solution:
> 
> 1. You need to check for in_size < 6, otherwise you read data that has
> not been written there during that request. I haven't tested this, but
> I'd expect it to fail for example if you try to send the two commands
> "00 00 00 00 00 02" and "00 00". The first will be rejected with
> EINVAL, because 6 (in_size) != 2 (commandSize). But the second will
> pass that check, because now in_size happens to match the commandSize
> that has only been written to the buffer for the first command.

AFAIK tpm_transmit checks that the command has at least the header.

> 2. You may not reject commands where in_size > commandSize, because
> TIS/PTP require the TPM to throw away extra bytes (and process the
> command as usual), not fail the command. You can see that in the State
> Transition Table (Table 18 in TIS 1.3), line 20, with the TPM in
> Reception state and Expect=0, writing more data does not change the
> state ("Write is not expected. Drop write. TPM ignores this state
> transition."). Of course, since we do not pass on in_size, but only
> commandSize the TPM will never see those extra bytes, but the external
> behavior (for user space applications) is identical.

OK, this is more relevant. What is the legit case to send extra bytes?

/Jarkko
