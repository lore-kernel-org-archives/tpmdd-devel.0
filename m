From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibmvtpm byteswapping inconsistency
Date: Thu, 26 Jan 2017 15:05:36 -0700
Message-ID: <20170126220536.GB31937@obsidianresearch.com>
References: <20170126212248.3f3e9103@kitsune.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170126212248.3f3e9103-6hIufAJW0g4CVLCxKZUutA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Michal Such??nek <msuchanek-l3A5Bk7waGM@public.gmane.org>, Nayna Jain <nayna-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 26, 2017 at 09:22:48PM +0100, Michal Such??nek wrote:

> This is repeated a few times in the driver so I added memset to quiet
> gcc and make behavior deterministic in case the unused fields get some
> meaning in the future.

Yep, reserved certainly needs to be zeroed.. Can you send a patch?
memset is overkill...

> However, in tpm_ibmvtpm_send the structure is initialized as
> 
> 	struct ibmvtpm_crq crq;
>         __be64 *word = (__be64 *)&crq;
> ...
>         crq.valid = (u8)IBMVTPM_VALID_CMD;
>         crq.msg = (u8)VTPM_TPM_COMMAND;
>         crq.len = cpu_to_be16(count);
>         crq.data = cpu_to_be32(ibmvtpm->rtce_dma_handle);
> 
> and submitted with
> 
> 	rc = ibmvtpm_send_crq(ibmvtpm->vdev, be64_to_cpu(word[0]),
>                               be64_to_cpu(word[1]));
> meaning it is swapped twice.

No idea, Nayna may know.

My guess is that '__be64 *word' should be 'u64 *word'...

Jason

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, SlashDot.org! http://sdm.link/slashdot
