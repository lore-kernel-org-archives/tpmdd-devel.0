From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [tpmdd-devel] [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Wed, 22 Feb 2017 12:39:19 -0500
Message-ID: <1487785159.2376.27.camel@HansenPartnership.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
         <20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
         <58AC85F2.5000406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <58AC85F2.5000406@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Nayna <nayna@linux.vnet.ibm.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, tpmdd-devel@lists.sourceforge.net
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, 2017-02-21 at 23:54 +0530, Nayna wrote:
> 
> On 02/17/2017 12:55 AM, Jarkko Sakkinen wrote:
> > Added an ability to virtualize TPM commands into an isolated 
> > context that we call a TPM space because the word context is 
> > already heavily used in the TPM specification. Both the handle 
> > areas and bodies (where necessary) are virtualized.
> > 
> > The mechanism works by adding a new parameter struct tpm_space to 
> > the tpm_transmit() function. This new structure contains the list 
> > of virtual handles and a buffer of page size (currently) for
> > backing storage.
> > 
> > When tpm_transmit() is called with a struct tpm_space instance it 
> > will execute the following sequence:
> > 
> > 1. Take locks.
> > 2. Load transient objects from the backing storage by using
> > ContextLoad
> >     and map virtual handles to physical handles.
> > 3. Perform the transaction.
> > 4. Save transient objects to backing storage by using ContextSave
> > and
> >     map resulting physical handle to virtual handle if there is
> > such.
> > 
> > This commit does not implement virtualization support for hmac and
> > policy sessions.
> > 
> 
> If I have understood discussions correctly, I assume, that kernel TPM
> operations will also be routed via RM. And I think that is not 
> happening now with these patches.
> 
> Am I missing something ?

Right at the moment the kernel use of tpm2 looks like

acquire chip->tpm_mutex
load key
process key
unload key
release chip->tpm_mutex

While it does this, there's no need for it to have a RM interface
because what it does between the acquisition and drop of the mutex
can't be seen by or have any effect on userspace (whether it uses the
RM or not).  So currently, the question doesn't arise, which is the
situation you see.

When the kernel needs to use resources that persisted beyond it
dropping the chip->tpm_mutex (say using policy or audit sessions), then
it would need to become a customer of the RM.

James

