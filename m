From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2 4/7] tpm: infrastructure for TPM spaces
Date: Wed, 22 Feb 2017 23:08:53 +0200
Message-ID: <20170222210853.lemfh54neoq4d6qw@intel.com>
References: <20170216192529.25467-1-jarkko.sakkinen@linux.intel.com>
	<20170216192529.25467-5-jarkko.sakkinen@linux.intel.com>
	<58AC85F2.5000406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58AC85F2.5000406-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Nayna <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Feb 21, 2017 at 11:54:50PM +0530, Nayna wrote:
> 
> 
> On 02/17/2017 12:55 AM, Jarkko Sakkinen wrote:
> > Added an ability to virtualize TPM commands into an isolated context
> > that we call a TPM space because the word context is already heavily
> > used in the TPM specification. Both the handle areas and bodies (where
> > necessary) are virtualized.
> > 
> > The mechanism works by adding a new parameter struct tpm_space to the
> > tpm_transmit() function. This new structure contains the list of virtual
> > handles and a buffer of page size (currently) for backing storage.
> > 
> > When tpm_transmit() is called with a struct tpm_space instance it will
> > execute the following sequence:
> > 
> > 1. Take locks.
> > 2. Load transient objects from the backing storage by using ContextLoad
> >     and map virtual handles to physical handles.
> > 3. Perform the transaction.
> > 4. Save transient objects to backing storage by using ContextSave and
> >     map resulting physical handle to virtual handle if there is such.
> > 
> > This commit does not implement virtualization support for hmac and
> > policy sessions.
> > 
> 
> If I have understood discussions correctly, I assume, that kernel TPM
> operations will also be routed via RM. And I think that is not happening now
> with these patches.
> 
> Am I missing something ?
> 
> Thanks & Regards,
>    - Nayna

Nope. It's not in the scope of this patch set and there are not
kernel use cases at the moment that would require it.

/Jarkko

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
