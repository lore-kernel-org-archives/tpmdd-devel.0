From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] tpm-emulator: add a TPM emulator pass
 through
Date: Mon, 09 Jan 2017 10:24:47 -0800
Message-ID: <1483986287.2398.5.camel@HansenPartnership.com>
References: <1483923513.2644.1.camel@HansenPartnership.com>
	<20170109154945.GA28023@obsidianresearch.com>
	<1483978982.2448.7.camel@HansenPartnership.com>
	<20170109165416.GA13960@obsidianresearch.com>
	<1483981445.2398.4.camel@HansenPartnership.com>
	<20170109171430.GA18648@obsidianresearch.com>
	<7bef4616-cd69-2798-fc1f-f7eee2fb8c98@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <7bef4616-cd69-2798-fc1f-f7eee2fb8c98-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Mon, 2017-01-09 at 13:03 -0500, Stefan Berger wrote:
> Examples:
> ./src/vtpmctrl --tpm2 \
>    --spawn /bin/swtpm chardev --tpm2 --fd %fd --tpmstate dir=/tmp

git head for swtpm is giving

Created TPM device /dev/tpm1; vTPM device has fd 4, major/minor = 247/1.
chardev: unrecognized option '--tpm2'

James


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
