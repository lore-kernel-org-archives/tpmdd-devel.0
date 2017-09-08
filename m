From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm-dev-common: Reject too short writes
Date: Sat, 9 Sep 2017 00:34:06 +0300
Message-ID: <20170908213406.zocwfmw5ulekaci3@linux.intel.com>
References: <20170904173642.5988-1-Alexander.Steffen@infineon.com>
 <20170906124233.qquzut5lyuri2buu@linux.intel.com>
 <20170906125033.32cwy27inzecfo3i@linux.intel.com>
 <f8ea7617d4da43439d59b30f4de63b87@MUCSE603.infineon.com>
 <20170907164656.skq6624og7xlmg5z@linux.intel.com>
 <a4bb005c917f436bb6d259092d6fcb47@MUCSE603.infineon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4bb005c917f436bb6d259092d6fcb47@MUCSE603.infineon.com>
Sender: stable-owner@vger.kernel.org
To: Alexander.Steffen@infineon.com
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, stable@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 08, 2017 at 02:26:42PM +0000, Alexander.Steffen@infineon.com wrote:
> > On Wed, Sep 06, 2017 at 02:19:28PM +0000,
> > Alexander.Steffen@infineon.com wrote:
> > > > On Wed, Sep 06, 2017 at 03:42:33PM +0300, Jarkko Sakkinen wrote:
> > > > > On Mon, Sep 04, 2017 at 07:36:42PM +0200, Alexander Steffen wrote:
> > > > > > tpm_transmit() does not offer an explicit interface to indicate the
> > > > > > number of valid bytes in the communication buffer. Instead, it
> > > > > > relies on the commandSize field in the TPM header that is encoded
> > within
> > > > the buffer.
> > > > > > Therefore, ensure that a) enough data has been written to the
> > > > > > buffer, so that the commandSize field is present and b) the
> > > > > > commandSize field does not announce more data than has been
> > written
> > > > to the buffer.
> > > > > >
> > > > > > This should have been fixed with CVE-2011-1161 long ago, but
> > > > > > apparently a correct version of that patch never made it into the
> > kernel.
> > > > > >
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Signed-off-by: Alexander Steffen
> > <Alexander.Steffen@infineon.com>
> > > > > > ---
> > > > > > v2:
> > > > > > - Moved all changes to tpm_common_write in a single patch.
> > > > > >
> > > > > >  drivers/char/tpm/tpm-dev-common.c | 3 ++-
> > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/drivers/char/tpm/tpm-dev-common.c
> > > > > > b/drivers/char/tpm/tpm-dev-common.c
> > > > > > index 610638a..ac25574 100644
> > > > > > --- a/drivers/char/tpm/tpm-dev-common.c
> > > > > > +++ b/drivers/char/tpm/tpm-dev-common.c
> > > > > > @@ -99,7 +99,8 @@ ssize_t tpm_common_write(struct file *file,
> > const
> > > > char __user *buf,
> > > > > >  	if (atomic_read(&priv->data_pending) != 0)
> > > > > >  		return -EBUSY;
> > > > > >
> > > > > > -	if (in_size > TPM_BUFSIZE)
> > > > > > +	if (in_size > sizeof(priv->data_buffer) || in_size < 6 ||
> > > > > > +	    in_size < be32_to_cpu(*((__be32 *) (buf + 2))))
> > > > > >  		return -E2BIG;
> > > > > >
> > > > > >  	mutex_lock(&priv->buffer_mutex);
> > > > > > --
> > > > > > 2.7.4
> > > > > >
> > > > >
> > > > > How did you test this change after you implemented it?
> > > > >
> > > > > Just thinking what to add to
> > > > > https://github.com/jsakkine-intel/tpm2-scripts
> > >
> > > I already had test cases that failed with some of my TPMs under some
> > circumstances. I'll try to come up with a concise description of what those
> > tests do or send you a patch directly for your tests. GitHub pull requests are
> > okay for that repository? (I already have one waiting there.)
> > >
> > > > >
> > > > > /Jarkko
> > > >
> > > > Just when I started to implement this that the bug fix itself does not have
> > yet
> > > > the right semantics.
> > > >
> > > > It should be just add a new check:
> > > >
> > > > if (in_size != be32_to_cpu(*((__be32 *) (buf + 2))))
> > > > 	return -EINVAL;
> > > >
> > > > The existing check is correct. This was missing. The reason for this is that
> > we
> > > > process whatever is in the in_size bytes as a full command.
> > >
> > > There are two problems with this solution:
> > >
> > > 1. You need to check for in_size < 6, otherwise you read data that has
> > > not been written there during that request. I haven't tested this, but
> > > I'd expect it to fail for example if you try to send the two commands
> > > "00 00 00 00 00 02" and "00 00". The first will be rejected with
> > > EINVAL, because 6 (in_size) != 2 (commandSize). But the second will
> > > pass that check, because now in_size happens to match the commandSize
> > > that has only been written to the buffer for the first command.
> > 
> > AFAIK tpm_transmit checks that the command has at least the header.
> 
> This was only a simple example, it will fail with other values as
> well. Just add 8 to both size fields and append 8 null bytes, and you
> will pass the length check in tpm_transmit but still have incorrect
> data. Also, it is probably no good style to omit checks for obvious
> errors, just because an unrelated check in a completely different
> location also happens to catch the problem under some circumstances.
> tpm_common_write discards the relevant information (in_size), so all
> other parts of the code need to be able to rely on it to have
> validated it properly.

I think any check should be done only in one place at the level where
it is required.

> > > 2. You may not reject commands where in_size > commandSize, because
> > > TIS/PTP require the TPM to throw away extra bytes (and process the
> > > command as usual), not fail the command. You can see that in the State
> > > Transition Table (Table 18 in TIS 1.3), line 20, with the TPM in
> > > Reception state and Expect=0, writing more data does not change the
> > > state ("Write is not expected. Drop write. TPM ignores this state
> > > transition."). Of course, since we do not pass on in_size, but only
> > > commandSize the TPM will never see those extra bytes, but the external
> > > behavior (for user space applications) is identical.
> > 
> > OK, this is more relevant. What is the legit case to send extra bytes?
> 
> For me: testing that my TPM implementation behaves correctly :) I can
> run the same test cases against the TPM using the Linux driver and
> several other, unrelated means. I'd like to avoid having special cases
> for communication paths in there, just because in one case I have a
> more direct channel to the TPM whereas in the other the Linux driver
> interferes with the communication and rejects the data before the TPM
> sees it. For "normal" usage from Linux applications this is not
> relevant, but it does not break anything either.
> 
> I've just noticed that the v2 patch is broken, because the code
> incorrectly tries to access data from user space. Interestingly, the
> tests worked fine on x86_64 and aarch64, only armv7l was broken (and
> that result somehow got lost, so I assumed that the patch was fine).
> I'll send a fixed patch soon.
> 
> Alexander

So what benefit do we get allowing garbage after the TPM command to
be sent? I think it makes more sense to allow only the command data
to be sent.

/Jarkko
