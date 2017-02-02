From: Michal =?UTF-8?B?U3VjaMOhbmVr?= <msuchanek@suse.de>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Thu, 2 Feb 2017 12:29:42 +0100
Message-ID: <20170202122942.7fd9988d@kitsune.suse.cz>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
        <20170126220536.GB31937@obsidianresearch.com>
        <024dadba-a75c-ab59-9d12-a9bea81f9bda@gmail.com>
        <F14AC3E9-E04F-4EF0-9C7E-999D481EA577@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F14AC3E9-E04F-4EF0-9C7E-999D481EA577@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vicky <honclo@linux.vnet.ibm.com>
Cc: Ashley Lai <ashleydlai@gmail.com>, Nayna Jain <nayna@linux.vnet.ibm.com>, Marcel Selhorst <tpmdd@selhorst.net>, linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, tpmdd-devel@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>, Peter Huewe <peterhuewe@gmx.de>, linuxppc-dev@lists.ozlabs.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, 1 Feb 2017 23:40:33 -0500
Vicky <honclo@linux.vnet.ibm.com> wrote:

> > On Jan 26, 2017, at 5:58 PM, Ashley Lai <ashleydlai@gmail.com>
> > wrote:
> > 
> > Adding Vicky from IBM.
> > 
> > 
> > On 01/26/2017 04:05 PM, Jason Gunthorpe wrote:  
> >> On Thu, Jan 26, 2017 at 09:22:48PM +0100, Michal Such??nek wrote:
> >>   
> >>> This is repeated a few times in the driver so I added memset to
> >>> quiet gcc and make behavior deterministic in case the unused
> >>> fields get some meaning in the future.  
> >> Yep, reserved certainly needs to be zeroed.. Can you send a patch?
> >> memset is overkill...
> >>   
> >>> However, in tpm_ibmvtpm_send the structure is initialized as
> >>> 
> >>> 	struct ibmvtpm_crq crq;
> >>>         __be64 *word = (__be64 *)&crq;
> >>> ...
> >>>         crq.valid = (u8)IBMVTPM_VALID_CMD;
> >>>         crq.msg = (u8)VTPM_TPM_COMMAND;
> >>>         crq.len = cpu_to_be16(count);
> >>>         crq.data = cpu_to_be32(ibmvtpm->rtce_dma_handle);
> >>> 
> >>> and submitted with
> >>> 
> >>> 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
> >>>                               be64_to_cpu(word[1]));
> >>> meaning it is swapped twice.  
> >> No idea, Nayna may know.
> >> 
> >> My guess is that '__be64 *word' should be 'u64 *word'...
> >> 
> >> Jason  
> >   
> 
> I don’t think we want ‘word' to be changed back to be of type
> ‘u64’.   Please see commit 62dfd912ab3b5405b6fe72d0135c37e9648071f1

The word is marked correctly as __be64 in that patch because count and
handle are swapped to BE when saved to it and the whole word is then
swapped again when loaded. If you just load ((u64)IBMVTPM_VALID_CMD <<
56 | ((u64)VTPM_TPM_COMMAND << 48) | ((u64)count << 32) |
ibmvtpm->rtce_dma_handle in a register it works equally well
without any __be and swaps involved.

Note however that __be64 and u64 are all the same to the compiler. It's
just a note for the reader and analysis tools.

Thanks

Michal
