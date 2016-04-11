From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH] tpm: fix crash in tpm_tis
Date: Mon, 11 Apr 2016 14:18:01 +0300
Message-ID: <20160411111801.GA8513@intel.com>
References: <1460033770-20586-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <65cbfbc2-d994-452d-851c-102831ea0837@email.android.com>
 <20160411084124.GA11322@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160411084124.GA11322@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Apr 11, 2016 at 11:41:24AM +0300, Jarkko Sakkinen wrote:
> On Thu, Apr 07, 2016 at 07:36:54AM -0700, Jason Gunthorpe wrote:
> >    I will have to look closer after the conference, but this does not look
> >    right.
> > 
> >    I vaguely recall commenting on this before. Move the shutdown into the
> >    core code to fix it.
> 
> This fix that I sent is not the right way to do it.
> 
> One example scenario:
> 
> 1. TIS driver gets detached, which causes tpm_tis_remove() to be called.
> 2. Some in-kernel subsystem uses TPM, which should not be done since the
>    hardware is already unitialized.
> 3. The devres subsystem sets ops to NULL.
> 
> Even though the fix is wrong I feel that it might put the rwsem into
> question.
> 
> I'm just thinking that maybe there could be a release callback in
> tpm_class_ops that could be called by tpm_del_char_device(). There can't
> be clients for the chip at that point so no synchronization mechanism
> is needed.

As a fix for this regression moving shutdown to tmp_chip_unregister() does
make more sense since the patch is already merged to next. Lets not get
stuck into locking discussion...

/Jarkko
