From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 10 Jan 2017 14:03:08 -0500
Message-ID: <o53b57$ac8$1@blaine.gmane.org>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
	<9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
	<20170105172726.GA11680@obsidianresearch.com>
	<1483641223.2515.62.camel@linux.vnet.ibm.com>
	<20170105192025.GB12587@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20170105192025.GB12587-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On 1/5/2017 2:20 PM, Jason Gunthorpe wrote:
>
> I'd rather give up features (eg policy sessions, if necessary) for the
> unpriv fd than give up security of the unpriv fd.

Please don't give up policy.  Nearly every use case of that we think of 
for TPM 2.0 uses policy sessions.

E.g.,

In 1.2, PCR authorization was built in to the object.  In 2.0, it's a 
policy.

In 1.2, key types were restricted to certain commands.  In 2.0, it's a 
policy.

Then there are all the new use cases - time restricted keys, use count 
restricted keys, keys with a PIN, etc., all use policy.

Even use of the EK primary key requires a policy, and that's needed for 
salt (getting the first password in securely) and attestation (proof 
that the TPM is authentic).



------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
