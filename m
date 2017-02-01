From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Fwd: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs
 support,for TPM 2.0 firmware event log
Date: Wed, 1 Feb 2017 16:48:59 +0200
Message-ID: <20170201144837.aenzg5cauzl2ofbt@intel.com>
References: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
 <CALAzByG474T_qSJ0Kry1LiNSsCQAHUagqcqtR_CnpporicZrdg@mail.gmail.com>
 <588F09A2.4090502@linux.vnet.ibm.com>
 <20170131174659.b6njebycqzd5ur6f@intel.com>
 <5890DAFC.9030407@linux.vnet.ibm.com>
 <20170131205006.fljtxsy4s6lyhkvv@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170131205006.fljtxsy4s6lyhkvv@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: Kenneth Goldman <kgoldman@us.ibm.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 31, 2017 at 10:50:06PM +0200, Jarkko Sakkinen wrote:
> On Wed, Feb 01, 2017 at 12:14:12AM +0530, Nayna wrote:
> > > I already sent my pull request to 4.11 and even today I found something
> > > fishy. You declared a function local array by using a variable in "tpm:
> > > enhance TPM 2.0 PCR extend to support multiple banks" (max_active_banks
> > > or something). And the event log patches have just passed the review.
> > 
> > Yes. I have checked using clang and it has passed the clang.. and I also
> > verified there were no complains during build.
> 
> What we can deduce from that is that they didn't expose the issue in
> question.
> 
> I found this by running sparse with make C=2 M=drives/char/tpm
> 
> > What type of problem do you see ?
> 
> It is disallowed to do stack allocation in the kernel code even if C
> standard would allow it. Stack is scarce resource so you need to know
> its usage at compile time.
> 
> In this case you actually know the allocation because the value is not
> changed during the course of the function but it is still bad. Probably
> compiler will optimize it out. Still it is not a good practice.
> 
> > Also, to understand, this is related to multi-bank patchset. I mean how does
> > it affect for event log patchset ?
> 
> Well in both cases these have landed fairly late but I asked from James
> whether I'll have to postpone these to 4.12.
> 
> Usually when I've sent my release pull request I do not want to make any
> radical changes to the codebase because they always require extra QA and
> thus take extra time.

rc = tpm_transmit_cmd(chip, buf.data, tpm_buf_length(&buf), 0, 0,
		      "attempting extend a PCR value");

This should be

rc = tpm_transmit_cmd(chip, buf.data, PAGE_SIZE, 0, 0,
		      "attempting extend a PCR value");

The second parameter is the size of the buffer, not length of the input
data.

I'll update this...

/Jarkko


