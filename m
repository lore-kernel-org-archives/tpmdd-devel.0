From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH v9 2/2] tpm: add securityfs support,for TPM
 2.0 firmware event log
Date: Thu, 26 Jan 2017 01:06:51 +0200
Message-ID: <20170125230651.zwvcyxpcrssfhyfu@intel.com>
References: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <de409ad1-de39-20d2-bda6-5d2a965e7256@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Ken Goldman <kgold@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 25, 2017 at 04:22:45PM -0500, Ken Goldman wrote:
> > You do not need to send a new patch set version as long as this
> > one gets peer tested. And it needs to be tested without hacks
> > like plumbing TCPA with TPM 2.0 in QEMU. OF code paths needs to
> > be peer tested to be more specific.
> > 
> > For me the code itself looks good but I simply cannot take it in
> > in the current situation.
> > 
> > /Jarkko
> 
> Tested-by: Kenneth Goldman <kgold@linux.vnet.ibm.com>
> 
> I validated a firmware event log taken from a Power 8 against PCR 0-7 values
> for the SHA-1 and SHA-256 banks from a Nuvoton TPM 2.0 chip on that same
> platform.

Thank you! I'll add this to the commit.

/Jarkko
