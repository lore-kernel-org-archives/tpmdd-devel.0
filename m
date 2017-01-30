From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Fwd: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs
 support,for TPM 2.0 firmware event log
Date: Mon, 30 Jan 2017 23:49:05 +0200
Message-ID: <20170130214905.4bkvv2yrmzprn2la@intel.com>
References: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
 <CALAzByG474T_qSJ0Kry1LiNSsCQAHUagqcqtR_CnpporicZrdg@mail.gmail.com>
 <588F09A2.4090502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <588F09A2.4090502@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>
Cc: Kenneth Goldman <kgoldman@us.ibm.com>, "moderated list:TPM DEVICE DRIVER" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, Jan 30, 2017 at 03:08:42PM +0530, Nayna wrote:
> 
> > From: "Ken Goldman" <kgold@linux.vnet.ibm.com
> > <mailto:kgold@linux.vnet.ibm.com>>
> > Date: 26-Jan-2017 2:53 AM
> > Subject: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs
> > support,for TPM 2.0 firmware event log
> > To: <linux-kernel@vger.kernel.org
> > <mailto:linux-kernel@vger.kernel.org>>,
> > <linux-security-module@vger.kernel.org
> > <mailto:linux-security-module@vger.kernel.org>>,
> > <tpmdd-devel@lists.sourceforge.net
> > <mailto:tpmdd-devel@lists.sourceforge.net>>
> > Cc:
> > 
> >     You do not need to send a new patch set version as long as this
> >     one gets peer tested. And it needs to be tested without hacks
> >     like plumbing TCPA with TPM 2.0 in QEMU. OF code paths needs to
> >     be peer tested to be more specific.
> > 
> >     For me the code itself looks good but I simply cannot take it in
> >     in the current situation.
> > 
> >     /Jarkko
> > 
> > 
> > Tested-by: Kenneth Goldman <kgold@linux.vnet.ibm.com
> > <mailto:kgold@linux.vnet.ibm.com>>
> > 
> > I validated a firmware event log taken from a Power 8 against PCR 0-7
> > values for the SHA-1 and SHA-256 banks from a Nuvoton TPM 2.0 chip on
> > that same platform.
> > 
> 
> Thank You Ken.
> 
> Jarkko, I hope now these patches can be accepted for 4.11.
> 
> Thanks & Regards,
>    - Nayna

Thanks Ken. I somehow managed to miss that response.

/Jarkko
