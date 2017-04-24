From: Paul Menzel <pmenzel-KUpvgZVWgV9o1qOY/usvUg@public.gmane.org>
Subject: Re: What does error code 38 mean?
Date: Mon, 24 Apr 2017 16:50:22 +0200
Message-ID: <0603ee8e-ce81-9a46-4bb3-5fe4d7bda463@molgen.mpg.de>
References: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <trinity-decde0f7-fedc-4dc2-b8e0-87a910625951-1492997557494@msvc-mesg-gmx108>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Cc: Patrick Rudolph <siro-afHDD34IFkZrovVCs/uTlw@public.gmane.org>, Arthur Heymans <arthur-ohM3iTZxzbjrDilwLfPoKQ@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Dear Peter, dear TPM folks,


On 04/24/17 03:32, Peter Huewe wrote:

>> x60t kernel: tpm tpm0: A TPM error (38) occurred continue selftest
>
> 38=0x26= invalid post init, which means tpm did not receive tpm_startup command
> after reset.

Thank you for the quick reply. As this is during resume, could you 
please point me to documentation, what is expected for resume from the 
firmware?


Kind regards,

Paul

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
